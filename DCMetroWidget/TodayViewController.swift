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

var currentLocation: CLLocation = CLLocation()
var sixClosestStations: [Station] = []
var timeBefore: NSDate? = nil

class TodayViewController: NSViewController, NCWidgetProviding, NSTableViewDelegate, NSTableViewDataSource, CLLocationManagerDelegate {
	
	@IBOutlet weak var selectedStationLabel: NSTextField!
	@IBOutlet weak var selectedStationLabelHeightConstraint: NSLayoutConstraint!
	
	@IBOutlet weak var predictionTableView: NSTableView!
	@IBOutlet weak var predictionTableViewHeightConstraint: NSLayoutConstraint!
	
	@IBOutlet weak var getCurrentLocationButton: NSButton!
	
	var settingsViewController: SettingsViewController?
	
	let locationManager = CLLocationManager()
	
	let HEADER_HEIGHT = 23
	let ROW_HEIGHT = 17
	let ROW_SPACING = 6
	
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
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TodayViewController.setSelectedStationLabelAndReloadTable(_:)),name:"reloadTable", object: nil)
	}
	
	override func viewWillAppear() {
		super.viewWillAppear()
		
		if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Authorized || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined {
			locationManager.startUpdatingLocation()
		} else {
			predictionTableView.hidden = true
			selectedStationLabel.hidden = true
		}
	}
	
	@IBAction func touchSettings(sender: NSButton) {
		if settingsViewController == nil {
			settingsViewController = SettingsViewController.init(nibName: "SettingsViewController", bundle: NSBundle.mainBundle())
		}
		
		presentViewControllerInWidget(settingsViewController)
	}
	
	func setSelectedStationLabelAndReloadTable(notification: NSNotification) {
		dispatch_async(dispatch_get_main_queue(), {
			self.self.selectedStationLabel.stringValue = selectedStation.description
			self.selectedStationLabelHeightConstraint.constant = 23
			
			self.predictionTableViewHeightConstraint.constant = CGFloat(self.HEADER_HEIGHT + trains.count * (self.ROW_HEIGHT + self.ROW_SPACING))
			self.predictionTableView.reloadData()
		})
	}
	
// MARK: TableView
	
	func numberOfRowsInTableView(tableView: NSTableView) -> Int {
		return trains.count ?? 0
	}
	
	func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
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
		
		return nil
	}
	
	// from http://stackoverflow.com/a/25952895
	func getTintedImage(image:NSImage, tint:NSColor) -> NSImage {
		let tinted = image.copy() as! NSImage
		tinted.lockFocus()
		tint.set()
		
		let imageRect = NSRect(origin: NSZeroPoint, size: image.size)
		NSRectFillUsingOperation(imageRect, NSCompositingOperation.CompositeSourceAtop)
		
		tinted.unlockFocus()
		return tinted
	}
	
// MARK: Location
	
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [AnyObject]) {
		locationManager.stopUpdatingLocation()
		
		let timeAfter = NSDate()
		
		// only fetch new predictions if it has been at least one second since they were last fetched
		if timeBefore == nil || timeAfter.timeIntervalSinceDate(timeBefore!) > 1 {
			getCurrentLocationButton.hidden = true
			predictionTableView.hidden = false
			selectedStationLabel.hidden = false
			
			currentLocation = locationManager.location!
			sixClosestStations = getSixClosestStations(currentLocation)
			
			if !radioButtonClicked {
				selectedStation = sixClosestStations[0]
			}
			
			setSelectedStationLabelAndGetPredictions()
		}
	}
	
	@IBAction func getCurrentLocation(sender: NSButton) {
		locationManager.startUpdatingLocation()
	}
	
// MARK: Editing
	
	var widgetAllowsEditing: Bool {
		return false
	}
	
	func widgetDidBeginEditing() {
		debugPrint("began editing")
		// This causes the view to flash back and forth
		//		presentViewControllerInWidget(settingsViewController)
	}
	
	func widgetDidEndEditing() {
		debugPrint("ended editing")
	}
}