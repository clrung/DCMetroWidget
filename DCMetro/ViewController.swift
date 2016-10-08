//
//  ViewController.swift
//  DCMetro
//
//  Created by Christopher Rung on 4/27/16.
//  Copyright © 2016 Christopher Rung. All rights reserved.
//

import Cocoa
import WMATAFetcher

class ViewController: NSViewController {
	
	@IBOutlet weak var homeStationPopUpButton: NSPopUpButton!
	@IBOutlet weak var workStationPopUpButton: NSPopUpButton!
	
	let sharedDefaults = UserDefaults.init(suiteName: "2848SVWH7M.DCMetro")!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupPopUpButtons()
	}
	
	override var representedObject: Any? {
		didSet {
			// Update the view, if already loaded.
		}
	}
	
	@IBAction func clickGithubButton(_ sender: NSButton) {
		NSWorkspace.shared().open(URL(string: "https://github.com/clrung/DCMetroWidget")!)
	}

	@IBAction func clickPersonalWebsiteButton(_ sender: NSButton) {
		NSWorkspace.shared().open(URL(string: "https://christopherrung.com/contact/")!)
	}
	
	func setupPopUpButtons() {
		let sortedStations = Station.allValues.sorted( by: { $0.description < $1.description } )
		for station in sortedStations {
			homeStationPopUpButton.addItem(withTitle: station.description)
			homeStationPopUpButton.item(withTitle: station.description)?.representedObject = station.rawValue
			
			workStationPopUpButton.addItem(withTitle: station.description)
			workStationPopUpButton.item(withTitle: station.description)?.representedObject = station.rawValue
		}
		
		if let homeStationCode = sharedDefaults.string(forKey: "homeStation") {
			let homeStation = Station(rawValue: homeStationCode)!
			homeStationPopUpButton.selectItem(withTitle: homeStation.description)
		} else {
			homeStationPopUpButton.selectItem(withTitle: "")
		}
		if let workStationCode = sharedDefaults.string(forKey: "workStation") {
			let workStation = Station(rawValue: workStationCode)!
			workStationPopUpButton.selectItem(withTitle: workStation.description)
		} else {
			workStationPopUpButton.selectItem(withTitle: "")
		}
	}
	
	@IBAction func touchStationPopupbutton(_ sender: NSPopUpButtonCell) {
		sharedDefaults.set(sender.selectedItem!.representedObject, forKey: sender.identifier!)
		sharedDefaults.synchronize()
	}
	
}
