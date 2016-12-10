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
var selectedStation: Station = Station(rawValue: UserDefaults.standard.string(forKey: "selectedStation") ?? "No")!
var currentLocation: CLLocation? = nil

class MainViewController: NSViewController, NCWidgetProviding, NSTableViewDelegate, NSTableViewDataSource, CLLocationManagerDelegate {
	
	@IBOutlet weak var selectedStationLabel: NSTextField!
	var selectStationString = "Select a station in Settings"
	
	@IBOutlet weak var homeFavoriteButton: NSButton!
	@IBOutlet weak var workFavoriteButton: NSButton!
	
	@IBOutlet weak var mainPredictionView: NSScrollView!
	@IBOutlet weak var predictionTableView: NSTableView!
	@IBOutlet weak var predictionTableViewHeightConstraint: NSLayoutConstraint!
	
	@IBOutlet weak var errorTextField: NSTextField!
	
	let sharedDefaults = UserDefaults.init(suiteName: "2848SVWH7M.DCMetro")!
	
	let HEADER_HEIGHT = 23
	let ROW_HEIGHT = 17
	let ROW_SPACING = 6
	let SPACE_HEIGHT = 3
	
	var trains = [Train]()
	
	override var nibName: String? {
		return "TodayViewController"
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
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
		
		homeFavoriteButton.isHidden = sharedDefaults.string(forKey: "homeStation") == nil ? true : false
		workFavoriteButton.isHidden = sharedDefaults.string(forKey: "workStation") == nil ? true : false
		
		if selectedStation != Station.No {
			didSelectStation = true
		}
		
		selectedStationLabel.stringValue = didSelectStation ? selectedStation.description : selectStationString
		
		if CLLocationManager.authorizationStatus() == .authorized || CLLocationManager.authorizationStatus() == .notDetermined {
			selectedStationLabel.stringValue = "Loading..."
			LocationManager.sharedManager.startUpdatingLocation()
		} else {	// Denied or Restricted
			if didSelectStation {
				getPredictionsForSelectedStation()
			}
		}
	}
	
	@IBAction func clickFavoriteStation(_ sender: NSButton) {
		selectedStation = Station(rawValue: sharedDefaults.string(forKey: sender.identifier!)!)!
		UserDefaults.standard.set(selectedStation.rawValue, forKey: "selectedStation")
		getPredictionsForSelectedStation()
	}
	
	func setSelectedStationLabelAndReloadTable() {
		self.errorTextField.isHidden = true
		self.mainPredictionView.isHidden = false
		
		DispatchQueue.main.async(execute: {
			self.selectedStationLabel.stringValue = selectedStation.description
			
			let trainsHeight = self.trains.count * (self.ROW_HEIGHT + self.ROW_SPACING)
			let spacesHeight = WMATAfetcher.getSpaceCount(trains: self.trains) * (self.ROW_HEIGHT - self.SPACE_HEIGHT)
			
			self.predictionTableViewHeightConstraint.constant = CGFloat(self.HEADER_HEIGHT + trainsHeight - spacesHeight)
			self.predictionTableView.reloadData()
		})
	}
	
	func displayError(_ error: String) {
		DispatchQueue.main.async(execute: {
			self.selectedStationLabel.stringValue = selectedStation.description
			self.errorTextField.isHidden = false
			self.errorTextField.stringValue = error
			self.mainPredictionView.isHidden = true
		})
	}
	
	// MARK: TableView
	
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
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
			if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
				predictionTableView.noteHeightOfRows(withIndexesChanged: IndexSet(integer: 1))
				cell.textField?.stringValue = text
				cell.imageView?.image = circleImage ?? nil
				return cell
			}
		}
		
		return nil
	}
	
	// Source: http://stackoverflow.com/a/25952895
	func getTintedImage(_ image:NSImage, tint:NSColor) -> NSImage {
		let tinted = image.copy() as! NSImage
		tinted.lockFocus()
		tint.set()
		
		let imageRect = NSRect(origin: NSZeroPoint, size: image.size)
		NSRectFillUsingOperation(imageRect, NSCompositingOperation.sourceAtop)
		
		tinted.unlockFocus()
		return tinted
	}
	
	func numberOfRows(in tableView: NSTableView) -> Int {
		return self.trains.count
	}
	
	func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		if self.trains[row].group == "-1" {
			return CGFloat(SPACE_HEIGHT)
		} else {
			return CGFloat(ROW_HEIGHT)
		}
	}
	
	// MARK: Location
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		currentLocation = LocationManager.sharedManager.location
		LocationManager.sharedManager.stopUpdatingLocation()
		
		if currentLocation != nil {
			fiveClosestStations = WMATAfetcher.getClosestStations(location: currentLocation!, numStations: 5)
			if !didSelectStation {
				selectedStation = fiveClosestStations[0]
			}
			
			getPredictionsForSelectedStation()
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		LocationManager.sharedManager.stopUpdatingLocation()
		
		if didSelectStation {
			selectedStationLabel.stringValue = selectedStation.description
			getPredictionsForSelectedStation()
		} else {
			selectedStationLabel.stringValue = selectStationString
		}
		
		switch (error as NSError).code {
		case CLError.Code.denied.rawValue:
			self.displayError("Location services denied")
		case CLError.Code.locationUnknown.rawValue:
			self.displayError("Current location could not be determined")
		default:
			return
		}
	}
	
	/**
	Wrapper method that calls getPrediction(), passing it the selectedStation.
	*/
	func getPredictionsForSelectedStation() {
		WMATAfetcher.getStationPredictions(stationCode: selectedStation.rawValue, onCompleted: {
			trainResponse in
			if trainResponse.errorCode == nil {
				self.trains = trainResponse.trains!
				if self.trains.count > 0 {
					self.setSelectedStationLabelAndReloadTable()
				} else {
					self.displayError("No trains are currently arriving at \(selectedStation.description).")
				}
			} else {
				switch trainResponse.errorCode! {
				case -1009:
					self.displayError("Internet connection is offline")
				default:
					self.displayError("Prediction fetch failed (Code: \(trainResponse.errorCode!))")
				}
			}
		})
	}
	
	func DictionaryOfInstanceVariables(_ container:AnyObject, objects: String ...) -> [String:AnyObject] {
		var views = [String:AnyObject]()
		for objectName in objects {
			guard let object = object_getIvar(container, class_getInstanceVariable(type(of: container), objectName)) else {
				assertionFailure("\(objectName) is not an ivar of: \(container)");
				continue
			}
			views[objectName] = object as AnyObject?
		}
		return views
	}
}
