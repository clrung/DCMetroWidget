//
//  TodayViewController.swift
//  DCMetroWidget
//
//  Created by Christopher Rung on 4/27/16.
//  Copyright © 2016 Christopher Rung. All rights reserved.
//

import Cocoa
import NotificationCenter
import SwiftyJSON
import CoreLocation

var currentLocation: CLLocation! = nil
var fiveClosestStations: [Station] = []

class TodayViewController: NSViewController, NCWidgetProviding, NSTableViewDelegate, NSTableViewDataSource, CLLocationManagerDelegate {
	
	@IBOutlet weak var selectedStationLabel: NSTextField!
	var selectStationString = "Please select a station in Settings"
	
	@IBOutlet weak var mainPredictionView: NSScrollView!
	@IBOutlet weak var predictionTableView: NSTableView!
	@IBOutlet weak var predictionTableViewHeightConstraint: NSLayoutConstraint!
	
	@IBOutlet weak var getCurrentLocationButton: NSButton!
	
	@IBOutlet weak var errorTextField: NSTextField!
	
	var settingsViewController: SettingsViewController?
	
	let locationManager = CLLocationManager()
	
	let HEADER_HEIGHT = 23
	let ROW_HEIGHT = 17
	let ROW_SPACING = 6
	let SPACE_HEIGHT = 3
	
	override var nibName: String? {
		return "TodayViewController"
	}
	
	func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
		// Update your data and prepare for a snapshot. Call completion handler when you are done
		// with NoData if nothing has changed or NewData if there is new data since the last
		// time we called you
		completionHandler(.NoData)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
		locationManager.distanceFilter = kCLDistanceFilterNone
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(setSelectedStationLabelAndReloadTable(_:)), name:"reloadTable", object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(displayError(_:)), name:"error", object: nil)
	}
	
	override func viewWillAppear() {
		super.viewWillAppear()
		
		if selectedStation != Station.No {
			didSelectStation = true
		}
		
		selectedStationLabel.stringValue = selectedStation == Station.No ? selectStationString : selectedStation.description
		
		switch CLLocationManager.authorizationStatus() {
		case CLAuthorizationStatus.Authorized:
			if !didSelectStation {
				selectedStationLabel.stringValue = "Determining closest station..."
			}
			locationManager.startUpdatingLocation()
		case CLAuthorizationStatus.NotDetermined:
			getCurrentLocationButton.hidden = false
			mainPredictionView.hidden = true
		default:	// Denied or Restricted
			getPredictionsForSelectedStation()
		}
	}
	
	@IBAction func touchSettings(sender: NSButton) {
		if settingsViewController == nil {
			settingsViewController = SettingsViewController.init(nibName: "SettingsViewController", bundle: NSBundle.mainBundle())
		}
		
		presentViewControllerInWidget(settingsViewController)
	}
	
	func setSelectedStationLabelAndReloadTable(notification: NSNotification) {
		self.selectedStationLabel.stringValue = selectedStation.description
		
		self.getCurrentLocationButton.hidden = true
		self.errorTextField.hidden = true
		self.mainPredictionView.hidden = false
		
		dispatch_async(dispatch_get_main_queue(), {
			let trainsHeight = trains.count * (self.ROW_HEIGHT + self.ROW_SPACING)
			let spacesHeight = spaceCount * (self.ROW_HEIGHT - self.SPACE_HEIGHT)
			
			self.predictionTableViewHeightConstraint.constant = CGFloat(self.HEADER_HEIGHT + trainsHeight - spacesHeight)
			self.predictionTableView.reloadData()
		})
	}
	
	func displayError(notification: NSNotification) {
		let userInfo:Dictionary<String, String> = notification.userInfo as! Dictionary<String, String>
		
		dispatch_async(dispatch_get_main_queue(), {
			self.getCurrentLocationButton.hidden = true
			self.errorTextField.hidden = false
			self.errorTextField.stringValue = userInfo["errorString"]!
			self.mainPredictionView.hidden = true
		})
	}
	
	// MARK: TableView
	
	func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
		if row < trains.count {
			let item = trains[row]
			
			var lineImage = NSImage(named: "lineImage")
			var text = ""
			var cellIdentifier: String = ""
			
			if tableColumn == tableView.tableColumns[0] {
				cellIdentifier = "lineCell"
				lineImage = item.line != Line.NO ? getTintedImage(lineImage!, tint: item.line.color) : nil
			} else if tableColumn == tableView.tableColumns[1] {
				cellIdentifier = "carsCell"
				text = String(item.numCars)
			} else if tableColumn == tableView.tableColumns[2] {
				cellIdentifier = "destinationCell"
				text = item.destination.description
			} else if tableColumn == tableView.tableColumns[3] {
				cellIdentifier = "minCell"
				text = String(item.min)
			}
			
			if let cell = tableView.makeViewWithIdentifier(cellIdentifier, owner: nil) as? NSTableCellView {
				predictionTableView.noteHeightOfRowsWithIndexesChanged(NSIndexSet(index: 1))
				cell.textField?.stringValue = text
				cell.imageView?.image = lineImage ?? nil
				return cell
			}
		}
		
		return nil
	}
	
	// Source: http://stackoverflow.com/a/25952895
	func getTintedImage(image:NSImage, tint:NSColor) -> NSImage {
		let tinted = image.copy() as! NSImage
		tinted.lockFocus()
		tint.set()
		
		let imageRect = NSRect(origin: NSZeroPoint, size: image.size)
		NSRectFillUsingOperation(imageRect, NSCompositingOperation.CompositeSourceAtop)
		
		tinted.unlockFocus()
		return tinted
	}
	
	func numberOfRowsInTableView(tableView: NSTableView) -> Int {
		return trains.count ?? 0
	}
	
	func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		if trains[row].group != "-1" {
			return CGFloat(ROW_HEIGHT)
		} else {
			return CGFloat(SPACE_HEIGHT)
		}
	}
	
	// MARK: Location
	
	@IBAction func getCurrentLocation(sender: NSButton) {
		locationManager.startUpdatingLocation()
	}
	
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [AnyObject]) {
		locationManager.stopUpdatingLocation()
		
		if locationManager.location != nil {
			currentLocation = locationManager.location!
			
			fiveClosestStations = getfiveClosestStations(currentLocation)
			
			if !didSelectStation {
				selectedStation = fiveClosestStations[0]
			}
			
			getPredictionsForSelectedStation()
			
			selectedStationLabel.stringValue = selectedStation.description
		}
	}
	
	func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
		locationManager.stopUpdatingLocation()
		
		if didSelectStation {
			selectedStationLabel.stringValue = selectedStation.description
			getPredictionsForSelectedStation()
		} else {
			selectedStationLabel.stringValue = selectStationString
		}
		
		var errorString = ""
		
		switch error.code {
		case CLError.Denied.rawValue:
			errorString = "Location services denied"
		case CLError.LocationUnknown.rawValue:
			errorString = "Current location could not be determined"
		default:
			return
		}
		
		NSNotificationCenter.defaultCenter().postNotificationName("error", object: nil, userInfo: ["errorString":errorString])
	}
	
	// MARK: Editing
	
	var widgetAllowsEditing: Bool {
		return false
	}
	
	func widgetDidBeginEditing() {
		print("began editing")
		// This causes the view to flash back and forth
		//		presentViewControllerInWidget(settingsViewController)
	}
	
	func widgetDidEndEditing() {
		print("ended editing")
	}
}