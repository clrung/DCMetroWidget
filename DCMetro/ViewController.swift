//
//  ViewController.swift
//  DCMetro
//
//  Created by Christopher Rung on 4/27/16.
//  Copyright © 2016 Christopher Rung. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
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
	
}