//
//  SettingsViewController.swift
//  DCMetro
//
//  Created by Christopher Rung on 6/30/16.
//  Copyright © 2016 Christopher Rung. All rights reserved.
//

import Cocoa
import NotificationCenter
import CoreLocation

var selectedStation: Station = Station.No
var didSelectStationInSettings: Bool = false

class SettingsViewController: NCWidgetListViewController {
	
	@IBOutlet weak var stationRadioButton1: NSButton!
	@IBOutlet weak var stationRadioButton2: NSButton!
	@IBOutlet weak var stationRadioButton3: NSButton!
	@IBOutlet weak var stationRadioButton4: NSButton!
	@IBOutlet weak var stationRadioButton5: NSButton!
	
	@IBOutlet weak var stationPopUpButton: NSPopUpButton!
	
	var stationRadioButtons: [NSButton] = []
	
	override var nibName: String? {
		return "SettingsViewController"
	}
	
	override func loadView() {
		super.loadView()
		
		self.preferredContentSize = NSSize(width: self.view.frame.size.width, height: self.view.frame.size.height)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		didSelectStationInSettings = false
		
		let sortedStations = Station.allValues.sort( { $0.description < $1.description } )
		
		for station in sortedStations {
			stationPopUpButton.addItemWithTitle(station.description)
			
			var rawValue = station.rawValue
			switch station.rawValue {
			case Station.C01.rawValue: rawValue = Station.A01.rawValue
			case Station.F01.rawValue: rawValue = Station.B01.rawValue
			case Station.E06.rawValue: rawValue = Station.B06.rawValue
			case Station.F03.rawValue: rawValue = Station.D03.rawValue
			default: break
			}
			
			stationPopUpButton.itemWithTitle(station.description)?.representedObject = rawValue
		}
		
		stationRadioButtons = [stationRadioButton1, stationRadioButton2, stationRadioButton3, stationRadioButton4, stationRadioButton5]
		if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Authorized || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined {
			for (index, radioButton) in stationRadioButtons.enumerate() {
				radioButton.hidden = false
				stationRadioButtons[index].title = fiveClosestStations[index].description
			}
		}
	}
	
	@IBAction func touchStationRadioButton(sender: NSButton) {
		for radioButton in stationRadioButtons {
			radioButton.state = NSOffState
		}
		
		sender.state = NSOnState
		
		let selectedStationCode = fiveClosestStations[sender.tag].rawValue
		
		selectedStation = Station(rawValue: selectedStationCode)!
		
		didSelectStationInSettings = true
		
		dismissViewController(self)
	}
	
	@IBAction func touchStationPopUpButton(sender: NSPopUpButton) {
		for radioButton in stationRadioButtons {
			radioButton.state = NSOffState
		}
		
		let selectedStationCode = sender.selectedItem?.representedObject as! String
		
		selectedStation = Station(rawValue: selectedStationCode)!
		
		didSelectStationInSettings = true
		
		dismissViewController(self)
	}
	
}