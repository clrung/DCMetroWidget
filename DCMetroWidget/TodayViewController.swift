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
import Fabric
import Crashlytics
import WMATAFetcher

var fiveClosestStations: [Station] = []
var WMATAfetcher = WMATAFetcher(WMATA_API_KEY: "[WMATA_KEY_GOES_HERE]")
var selectedStation: Station = Station(rawValue: NSUserDefaults.standardUserDefaults().stringForKey("selectedStation") ?? "No")!
var currentLocation: CLLocation? = nil

class TodayViewController: NSViewController, NCWidgetProviding, NSTableViewDelegate, NSTableViewDataSource, CLLocationManagerDelegate {
	
	@IBOutlet weak var selectedStationLabel: NSTextField!
	var selectStationString = "Select a station in Settings"
	
	@IBOutlet weak var homeFavoriteButton: NSButton!
	@IBOutlet weak var workFavoriteButton: NSButton!
	
	@IBOutlet weak var mainPredictionView: NSScrollView!
	@IBOutlet weak var predictionTableView: NSTableView!
	@IBOutlet weak var predictionTableViewHeightConstraint: NSLayoutConstraint!
	
	@IBOutlet weak var errorTextField: NSTextField!
	
	var settingsViewController: SettingsViewController?
	
	let sharedDefaults = NSUserDefaults.init(suiteName: "2848SVWH7M.DCMetro")!
	
	let HEADER_HEIGHT = 23
	let ROW_HEIGHT = 17
	let ROW_SPACING = 6
	let SPACE_HEIGHT = 3
	
	var trains = [Train]()
	
	override var nibName: String? {
		return "TodayViewController"
	}
	
	func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
		// Update your data and prepare for a snapshot. Call completion handler when you are done
		// with NoData if nothing has changed or NewData if there is new data since the last
		// time we called you
		completionHandler(.NoData)
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)!
		Crashlytics.sharedInstance().debugMode = true
		Fabric.with([Crashlytics.self])
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		LocationManager.sharedManager.delegate = self
	}
	
	override func viewWillAppear() {
		super.viewWillAppear()
		
		homeFavoriteButton.hidden = sharedDefaults.stringForKey("homeStation") == nil ? true : false
		workFavoriteButton.hidden = sharedDefaults.stringForKey("workStation") == nil ? true : false
		
		if selectedStation != Station.No {
			didSelectStation = true
		}
		
		selectedStationLabel.stringValue = didSelectStation ? selectedStation.description : selectStationString
		
		if CLLocationManager.authorizationStatus() == .Authorized || CLLocationManager.authorizationStatus() == .NotDetermined {
			selectedStationLabel.stringValue = "Loading..."
			LocationManager.sharedManager.startUpdatingLocation()
		} else {	// Denied or Restricted
			if didSelectStation {
				getPredictionsForSelectedStation()
			}
		}
	}
	
	@IBAction func clickSettings(sender: NSButton) {
		if settingsViewController == nil {
			settingsViewController = SettingsViewController.init(nibName: "SettingsViewController", bundle: NSBundle.mainBundle())
		}
		
		presentViewControllerInWidget(settingsViewController)
	}
	
	@IBAction func clickFavoriteStation(sender: NSButton) {
		selectedStation = Station(rawValue: sharedDefaults.stringForKey(sender.identifier!)!)!
		NSUserDefaults.standardUserDefaults().setObject(selectedStation.rawValue, forKey: "selectedStation")
		getPredictionsForSelectedStation()
	}
	
	func setSelectedStationLabelAndReloadTable() {
		self.errorTextField.hidden = true
		self.mainPredictionView.hidden = false
		
		dispatch_async(dispatch_get_main_queue(), {
			self.selectedStationLabel.stringValue = selectedStation.description

			let trainsHeight = self.trains.count * (self.ROW_HEIGHT + self.ROW_SPACING)
			let spacesHeight = WMATAfetcher.getSpaceCount(self.trains) * (self.ROW_HEIGHT - self.SPACE_HEIGHT)
			
			self.predictionTableViewHeightConstraint.constant = CGFloat(self.HEADER_HEIGHT + trainsHeight - spacesHeight)
			self.predictionTableView.reloadData()
		})
	}
	
	func displayError(error: String) {
		dispatch_async(dispatch_get_main_queue(), {
			self.errorTextField.hidden = false
			self.errorTextField.stringValue = error
			self.mainPredictionView.hidden = true
		})
	}
	
	// MARK: TableView
	
	func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
		if row < self.trains.count {
			let item = self.trains[row]
			
			var circleImage = NSImage(named: "Circle")
			var text = ""
			var cellIdentifier: String = ""
			
			if tableColumn == tableView.tableColumns[0] {
				cellIdentifier = "lineCell"
				circleImage = item.line != Line.NO ? getTintedImage(circleImage!, tint: item.line.color) : nil
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
				cell.imageView?.image = circleImage ?? nil
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
		return self.trains.count ?? 0
	}
	
	func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		if self.trains[row].group != "-1" {
			return CGFloat(ROW_HEIGHT)
		} else {
			return CGFloat(SPACE_HEIGHT)
		}
	}
	
	// MARK: Location
	
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [AnyObject]) {
        currentLocation = LocationManager.sharedManager.location
        if currentLocation != nil {
			fiveClosestStations = WMATAfetcher.getClosestStations(currentLocation!, numStations: 5)
			if !didSelectStation {
				selectedStation = fiveClosestStations[0]
			}
			
			getPredictionsForSelectedStation()
		}
		
		LocationManager.sharedManager.stopUpdatingLocation()
	}
	
	func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
		LocationManager.sharedManager.stopUpdatingLocation()
		
		if didSelectStation {
			selectedStationLabel.stringValue = selectedStation.description
			getPredictionsForSelectedStation()
		} else {
			selectedStationLabel.stringValue = selectStationString
		}
		
		switch error.code {
		case CLError.Denied.rawValue:
			self.displayError("Location services denied")
		case CLError.LocationUnknown.rawValue:
			self.displayError("Current location could not be determined")
		default:
			return
		}
	}
	
	/**
	Wrapper method that calls getPrediction(), passing it the selectedStation.
	*/
	func getPredictionsForSelectedStation() {
		WMATAfetcher.getStationPredictions(selectedStation.rawValue, onCompleted: {
			trainResponse in
			if trainResponse.error == nil {
				self.trains = trainResponse.trains!
				self.setSelectedStationLabelAndReloadTable()
			} else {
				self.displayError(trainResponse.error!)
			}
		})
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