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
	
	override func viewWillAppear() {
		super.viewWillAppear()
	}
	
	override func viewWillLayout() {
		super.viewWillLayout()
		
		stationRadioButtons = [stationRadioButton1, stationRadioButton2, stationRadioButton3, stationRadioButton4, stationRadioButton5]
		if currentLocation != nil {
			selectStationAndRadioButtonsHeightConstraint.constant = 23
			chooseFromListTextField.stringValue = "or choose from the list"
			for (index, radioButton) in stationRadioButtons.enumerated() {
				radioButton.isHidden = false
				let station = fiveClosestStations[index]
				stationRadioButtons[index].title = station.description + String(format: " (%@)", WMATAfetcher.getDistanceFromStation(location: currentLocation!, station: station, isMetric: false))
			}
		} else {
			selectStationAndRadioButtonsHeightConstraint.constant = 2
			chooseFromListTextField.stringValue = "Choose a station from the list"
			for radioButton in stationRadioButtons {
				radioButton.isHidden = true
			}
		}
	}
	
	func setupPopUpButton() {
		let sortedStations = Station.allValues.sorted( by: { $0.description < $1.description } )
		
		for station in sortedStations {
			stationPopUpButton.addItem(withTitle: station.description)
			
			var rawValue = station.rawValue
			switch rawValue {
			case Station.C01.rawValue: rawValue = Station.A01.rawValue
			case Station.F01.rawValue: rawValue = Station.B01.rawValue
			case Station.E06.rawValue: rawValue = Station.B06.rawValue
			case Station.F03.rawValue: rawValue = Station.D03.rawValue
			default: break
			}
			
			stationPopUpButton.item(withTitle: station.description)?.representedObject = rawValue
		}
		
		stationPopUpButton.selectItem(withTitle: selectedStation.description)
	}
	
	@IBAction func touchStationRadioButton(_ sender: NSButton) {
		setSelectedStation(fiveClosestStations[sender.tag].rawValue)
		sender.state = NSOnState
	}
	
	@IBAction func touchStationPopUpButton(_ sender: NSPopUpButton) {
		setSelectedStation(sender.selectedItem?.representedObject as! String)
	}
	
	func setSelectedStation(_ selectedStationCode: String) {
		for radioButton in stationRadioButtons {
			radioButton.state = NSOffState
		}
		
		selectedStation = Station(rawValue: selectedStationCode)!
		UserDefaults.standard.set(selectedStation.rawValue, forKey: "selectedStation")
		
		didSelectStation = true
	}
	
}
