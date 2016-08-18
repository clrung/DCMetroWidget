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
import WMATAFetcher

var didSelectStation: Bool = false

class SettingsViewController: NCWidgetListViewController {
	
	@IBOutlet weak var selectStationTextField: NSTextField!
	@IBOutlet weak var selectStationAndRadioButtonsHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var stationRadioButton1: NSButton!
	@IBOutlet weak var stationRadioButton2: NSButton!
	@IBOutlet weak var stationRadioButton3: NSButton!
	@IBOutlet weak var stationRadioButton4: NSButton!
	@IBOutlet weak var stationRadioButton5: NSButton!
	var stationRadioButtons: [NSButton] = []
	
	@IBOutlet weak var chooseFromListTextField: NSTextField!
	@IBOutlet weak var stationPopUpButton: NSPopUpButton!
	
	override var nibName: String? {
		return "SettingsViewController"
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupPopUpButton()
	}
	
	override func viewWillLayout() {
		super.viewWillLayout()
		
		stationRadioButtons = [stationRadioButton1, stationRadioButton2, stationRadioButton3, stationRadioButton4, stationRadioButton5]
		if LocationManager.sharedManager.location != nil {
			selectStationAndRadioButtonsHeightConstraint.constant = 23
			chooseFromListTextField.stringValue = "or choose from the list"
			for (index, radioButton) in stationRadioButtons.enumerate() {
				radioButton.hidden = false
				stationRadioButtons[index].title = fiveClosestStations[index].description
			}
		} else {
			selectStationAndRadioButtonsHeightConstraint.constant = 2
			chooseFromListTextField.stringValue = "Choose a station from the list"
			for radioButton in stationRadioButtons {
				radioButton.hidden = true
			}
		}
	}
	
	func setupPopUpButton() {
		let sortedStations = Station.allValues.sort( { $0.description < $1.description } )
		
		for station in sortedStations {
			stationPopUpButton.addItemWithTitle(station.description)
			
			var rawValue = station.rawValue
			switch rawValue {
			case Station.C01.rawValue: rawValue = Station.A01.rawValue
			case Station.F01.rawValue: rawValue = Station.B01.rawValue
			case Station.E06.rawValue: rawValue = Station.B06.rawValue
			case Station.F03.rawValue: rawValue = Station.D03.rawValue
			default: break
			}
			
			stationPopUpButton.itemWithTitle(station.description)?.representedObject = rawValue
		}
		
		stationPopUpButton.selectItemWithTitle(WMATAfetcher.selectedStation.description)
	}
	
	@IBAction func touchStationRadioButton(sender: NSButton) {
		setSelectedStationAndDismiss(fiveClosestStations[sender.tag].rawValue)
		sender.state = NSOnState
	}
	
	@IBAction func touchStationPopUpButton(sender: NSPopUpButton) {
		setSelectedStationAndDismiss(sender.selectedItem?.representedObject as! String)
	}
	
	func setSelectedStationAndDismiss(selectedStationCode: String) {
		for radioButton in stationRadioButtons {
			radioButton.state = NSOffState
		}
		
		WMATAfetcher.selectedStation = Station(rawValue: selectedStationCode)!
		NSUserDefaults.standardUserDefaults().setObject(WMATAfetcher.selectedStation.rawValue, forKey: "selectedStation")
		
		didSelectStation = true
		
		dismissViewController(self)
	}
	
}