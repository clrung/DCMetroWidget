//
//  ViewController.swift
//  DCMetro
//
//  Created by Christopher Rung on 4/27/16.
//  Copyright © 2016 Christopher Rung. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
	
	@IBOutlet weak var homeStationPopUpButton: NSPopUpButton!
	@IBOutlet weak var workStationPopUpButton: NSPopUpButton!
	
	let sharedDefaults = NSUserDefaults.init(suiteName: "com.clrungdev.DCMetroGroup")!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupPopUpButtons()
	}
	
	override var representedObject: AnyObject? {
		didSet {
			// Update the view, if already loaded.
		}
	}
	
	@IBAction func clickGithubButton(sender: NSButton) {
		NSWorkspace.sharedWorkspace().openURL(NSURL(string: "https://github.com/clrung/DCMetroWidget")!)
	}

	@IBAction func clickPersonalWebsiteButton(sender: NSButton) {
		NSWorkspace.sharedWorkspace().openURL(NSURL(string: "https://christopherrung.com/contact/")!)
	}
	
	func setupPopUpButtons() {
		let sortedStations = Station.allValues.sort( { $0.description < $1.description } )
		for station in sortedStations {
			homeStationPopUpButton.addItemWithTitle(station.description)
			homeStationPopUpButton.itemWithTitle(station.description)?.representedObject = station.rawValue
			
			workStationPopUpButton.addItemWithTitle(station.description)
			workStationPopUpButton.itemWithTitle(station.description)?.representedObject = station.rawValue
		}
		
		if let homeStationCode = sharedDefaults.stringForKey("homeStation") {
			let homeStation = Station(rawValue: homeStationCode)!
			homeStationPopUpButton.selectItemWithTitle(homeStation.description)
		} else {
			homeStationPopUpButton.selectItemWithTitle("")
		}
		if let workStationCode = sharedDefaults.stringForKey("workStation") {
			let workStation = Station(rawValue: workStationCode)!
			workStationPopUpButton.selectItemWithTitle(workStation.description)
		} else {
			workStationPopUpButton.selectItemWithTitle("")
		}
	}
	
	@IBAction func touchStationPopupbutton(sender: NSPopUpButtonCell) {
		sharedDefaults.setObject(sender.selectedItem!.representedObject, forKey: sender.identifier!)
		sharedDefaults.synchronize()
	}
	
}