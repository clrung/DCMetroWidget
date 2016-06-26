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

class TodayViewController: NSViewController, NCWidgetProviding, NSTableViewDelegate, NSTableViewDataSource, CLLocationManagerDelegate {
	
	@IBOutlet weak var predictionTableViewHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var predictionTableView: NSTableView!
	
	@IBOutlet weak var stationRadioButton1: NSButton!
	@IBOutlet weak var stationRadioButton2: NSButton!
	@IBOutlet weak var stationRadioButton3: NSButton!
	@IBOutlet weak var stationRadioButton4: NSButton!
	@IBOutlet weak var stationRadioButton5: NSButton!
	@IBOutlet weak var stationRadioButton6: NSButton!
	
	@IBOutlet weak var stationPopUpButton: NSPopUpButton!
	
	@IBOutlet weak var getCurrentLocationButton: NSButton!
	
	var predictionJSON: JSON = JSON(NSNull)
	var trains: [Train] = []
	
	let locationManager = CLLocationManager()
	var currentLocation: CLLocation = CLLocation()
	
	var selectedStation: Station = Station.A01
	
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
		locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
		locationManager.distanceFilter = kCLDistanceFilterNone;
		
		// TODO start the progress indicator
		
		self.trains = []
		
		getPrediction(selectedStation.rawValue, onCompleted: {
			// TODO stop the progress indicator
			
			self.populateTrainArray()
			
			// TODO the other 3 stations
			if self.selectedStation == Station.A01 {
				let trainsGroup1 = self.trains
				self.trains = []
				
				self.selectedStation = Station.C01
				self.getPrediction(self.selectedStation.rawValue, onCompleted: {
					self.populateTrainArray()
					
					self.trains = self.trains + trainsGroup1
					
					dispatch_async(dispatch_get_main_queue(), {
						self.predictionTableViewHeightConstraint.constant = CGFloat(self.HEADER_HEIGHT + self.trains.count * (self.ROW_HEIGHT + self.ROW_SPACING))
						self.predictionTableView.reloadData()
					})
				})
			}
			
			dispatch_async(dispatch_get_main_queue(), {
				self.predictionTableViewHeightConstraint.constant = CGFloat(self.HEADER_HEIGHT + self.trains.count * (self.ROW_HEIGHT + self.ROW_SPACING))
				self.predictionTableView.reloadData()
			})
			
		})
	}

	func populateTrainArray() {
		// the JSON only contains one root element, "Trains"
		self.predictionJSON = self.predictionJSON["Trains"]
		
		for (_, subJson): (String, JSON) in self.predictionJSON {
			var line: Line? = nil
			var min: String? = nil
			var numCars: String? = nil
			var destination: Station? = nil
			
			if subJson["DestinationName"].stringValue == Station.No.description || subJson["DestinationName"].stringValue == Station.Train.description {
				line = Line.NO
				min = "-"
				numCars = "-"
				destination = subJson["DestinationName"].stringValue == Station.No.description ? Station.No : Station.Train
			}
			
			if subJson["Min"].stringValue == "" {
				debugPrint("found empty min, skipping")
				continue
			}
			
			self.trains.append(Train(numCars: numCars ?? subJson["Car"].stringValue,
				destination: destination ?? Station(rawValue: subJson["DestinationCode"].stringValue)!,
				group: subJson["Group"].stringValue,
				line: line ?? Line(rawValue: subJson["Line"].stringValue)!,
				location: Station(rawValue: subJson["LocationCode"].stringValue)!,
				min: min ?? subJson["Min"].stringValue))
		}
		
		self.trains.sortInPlace({ $0.destination.description.compare($1.destination.description) == .OrderedAscending })
		self.trains.sortInPlace({ $0.group < $1.group })
		
		for train in self.trains {
			debugPrint(train.debugDescription)
		}
		debugPrint()
	}
	
	var widgetAllowsEditing: Bool {
		return true
	}
	
	func widgetDidBeginEditing() {
		debugPrint("began editing")
	}
	
	func widgetDidEndEditing() {
		debugPrint("ended editing in main")
	}
	
	func getPrediction(stationCode: String, onCompleted: () -> ()) {
		guard let wmataURL = NSURL(string: "https://api.wmata.com/StationPrediction.svc/json/GetPrediction/" + stationCode) else {
			debugPrint("Error: cannot create URL")
			return
		}
		
		let request = NSMutableURLRequest(URL: wmataURL)
		let session = NSURLSession.sharedSession()
		
		request.setValue("[WMATA_KEY_GOES_HERE]", forHTTPHeaderField:"api_key")
		
		let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) in
			if error == nil {
				self.predictionJSON = JSON(data: data!)

				onCompleted()
			} else {
				debugPrint(error)
			}
		})
		
		task.resume()
	}
	
	func numberOfRowsInTableView(tableView: NSTableView) -> Int {
		return trains.count ?? 0
	}
	
	func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		let item = trains[row]
		
		var lineColor = NSImage(named: "lineColor")
		var text = ""
		var cellIdentifier: String = ""
		
		if tableColumn == tableView.tableColumns[0] {
			cellIdentifier = "lineCell"
			lineColor = item.line != Line.NO ? getTintedImage(lineColor!, tint: item.line.color) : nil
		} else if tableColumn == tableView.tableColumns[1] {
			cellIdentifier = "timeCell"
			text = String(item.min)
		} else if tableColumn == tableView.tableColumns[2] {
			cellIdentifier = "carsCell"
			text = String(item.numCars)
		} else if tableColumn == tableView.tableColumns[3] {
			cellIdentifier = "destinationCell"
			text = item.destination.description
		}
		
		if let cell = tableView.makeViewWithIdentifier(cellIdentifier, owner: nil) as? NSTableCellView {
			cell.textField?.stringValue = text
			cell.imageView?.image = lineColor ?? nil
			return cell
		}
		
		return nil
	}
	
	@IBAction func touchStationRadioButton(sender: NSButton) {
		let stationRadioButtons = [stationRadioButton1, stationRadioButton2, stationRadioButton3, stationRadioButton4, stationRadioButton5, stationRadioButton6]
		
		for radioButton in stationRadioButtons {
			radioButton.state = NSOffState
		}
		
		sender.state = NSOnState
		
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
	
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [AnyObject]) {
		let stationRadioButtons = [stationRadioButton1, stationRadioButton2, stationRadioButton3, stationRadioButton4, stationRadioButton5, stationRadioButton6]
		
		for radioButton in stationRadioButtons {
			radioButton.hidden = false
		}
		
		getCurrentLocationButton.hidden = true
		
		currentLocation = locationManager.location!
		
		getSixClosestStations()
		
		// TODO stop the progress indicator
		
		locationManager.stopUpdatingLocation()
	}
	
	@IBAction func getCurrentLocation(sender: NSButton) {
		locationManager.startUpdatingLocation()
		// TODO start the progress indicator
	}
	
	func getSixClosestStations() -> [Station] {
		var sixClosestStations = [Station]()
		var distancesDictionary: [CLLocationDistance:String] = [:]
		
		for station in Station.allValues {
			distancesDictionary[station.location.distanceFromLocation(currentLocation)] = station.rawValue
		}
		
		let sortedDistancesKeys = Array(distancesDictionary.keys).sort(<)
		
		for (index, element) in sortedDistancesKeys.enumerate() {
			sixClosestStations.append(Station(rawValue: distancesDictionary[element]!)!)
			if index == 6 {
				break;
			}
		}
		
		return sixClosestStations
	}
}