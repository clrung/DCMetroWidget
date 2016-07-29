//
//  AppDelegate.swift
//  DCMetro
//
//  Created by Christopher Rung on 4/27/16.
//  Copyright © 2016 Christopher Rung. All rights reserved.
//

import Cocoa
import Fabric
import Crashlytics

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
		NSUserDefaults.standardUserDefaults().registerDefaults(["NSApplicationCrashOnExceptions" : true])
		Crashlytics.sharedInstance().debugMode = true
		Fabric.with([Crashlytics.self])
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

