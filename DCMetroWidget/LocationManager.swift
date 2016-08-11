//
//  LocationManager.swift
//  DC Metro
//
//  Created by Christopher Rung on 8/11/16.
//  Copyright © 2016 Christopher Rung. All rights reserved.
//

import CoreLocation

class LocationManager {
	static let sharedManager: CLLocationManager = {
		
		let locationManager = CLLocationManager()
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.distanceFilter = 100.0
		
		return locationManager
	}()
}