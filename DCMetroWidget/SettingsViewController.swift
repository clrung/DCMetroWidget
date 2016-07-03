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
var radioButtonClicked: Bool = false

class SettingsViewController: NCWidgetListViewController {
	
	@IBOutlet weak var stationRadioButton1: NSButton!
	@IBOutlet weak var stationRadioButton2: NSButton!
	@IBOutlet weak var stationRadioButton3: NSButton!
	@IBOutlet weak var stationRadioButton4: NSButton!
	@IBOutlet weak var stationRadioButton5: NSButton!
	@IBOutlet weak var stationRadioButton6: NSButton!
	
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
		
		stationRadioButtons = [stationRadioButton1, stationRadioButton2, stationRadioButton3, stationRadioButton4, stationRadioButton5, stationRadioButton6]
		
		if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Authorized || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined {
			for (index, radioButton) in stationRadioButtons.enumerate() {
				radioButton.hidden = false
				stationRadioButtons[index].title = sixClosestStations[index].description
			}
		}
	}
	
	override func viewDidAppear() {
		super.viewDidAppear()
		radioButtonClicked = false
	}
	
	@IBAction func touchStationRadioButton(sender: NSButton) {
		for radioButton in stationRadioButtons {
			radioButton.state = NSOffState
		}
		
		sender.state = NSOnState
		
		let selectedStationCode = sixClosestStations[sender.tag].rawValue
		
		selectedStation = Station(rawValue: selectedStationCode)!
		
		radioButtonClicked = true
	}
	
}