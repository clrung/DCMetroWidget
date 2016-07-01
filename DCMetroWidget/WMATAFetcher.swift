//
//  WMATAFetcher.swift
//  DCMetro
//
//  Created by Christopher Rung on 6/30/16.
//  Copyright © 2016 Christopher Rung. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreLocation

func getPrediction(stationCode: String, onCompleted: (result: JSON?) -> ()) {
	guard let wmataURL = NSURL(string: "https://api.wmata.com/StationPrediction.svc/json/GetPrediction/" + stationCode) else {
		debugPrint("Error: cannot create URL")
		return
	}
	
	let request = NSMutableURLRequest(URL: wmataURL)
	let session = NSURLSession.sharedSession()
	
	request.setValue("[WMATA_KEY_GOES_HERE]", forHTTPHeaderField:"api_key")
	
	session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) in
		if error == nil {			
			onCompleted(result: JSON(data: data!))
		} else {
			debugPrint(error)
		}
	}).resume()
}

func getSixClosestStations(location: CLLocation) -> [Station] {
	var sixClosestStations = [Station]()
	var distancesDictionary: [CLLocationDistance:String] = [:]
	
	for station in Station.allValues {
		distancesDictionary[station.location.distanceFromLocation(location)] = station.rawValue
	}
	
	let sortedDistancesKeys = Array(distancesDictionary.keys).sort(<)
	
	for (index, key) in sortedDistancesKeys.enumerate() {
		sixClosestStations.append(Station(rawValue: distancesDictionary[key]!)!)
		if index == 6 {
			break;
		}
	}
	
	return sixClosestStations
}