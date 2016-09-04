//
//  TodayViewController.swift
//  DC Metro
//
//  Created by Christopher Rung on 9/3/16.
//  Copyright © 2016 Christopher Rung. All rights reserved.
//

import Foundation
import Cocoa

class TodayViewController: NSViewController {
	
	@IBOutlet var mainViewController: MainViewController!
	@IBOutlet var settingsViewController: SettingsViewController!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		mainViewController.view.translatesAutoresizingMaskIntoConstraints = false
		settingsViewController.view.translatesAutoresizingMaskIntoConstraints = false
		self.view.translatesAutoresizingMaskIntoConstraints = false
		
		switchFromViewController(nil, toViewController: mainViewController)
	}
	
	// MARK: Editing
	
	var widgetAllowsEditing: Bool {
		return true
	}
	
	func widgetDidBeginEditing() {
		switchFromViewController(mainViewController, toViewController: settingsViewController)
	}
	
	func widgetDidEndEditing() {
		switchFromViewController(settingsViewController, toViewController: mainViewController)
	}
	
	func switchFromViewController(fromViewController: NSViewController?, toViewController: NSViewController?) {
		if fromViewController != nil {
			fromViewController?.removeFromParentViewController()
			fromViewController?.view.removeFromSuperview()
		}
		
		if toViewController != nil {
			self.addChildViewController(toViewController!)
			let view = toViewController!.view
			self.view.addSubview(view)
			let views: [String:AnyObject] = ["view" : view]
			self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: [], metrics: nil, views: views))
			self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: [], metrics: nil, views: views))
		}
		
		self.view.layoutSubtreeIfNeeded()
	}
}