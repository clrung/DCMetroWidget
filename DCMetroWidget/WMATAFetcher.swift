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

var predictionJSON: JSON = JSON.null
var trains: [Train] = []
//						Metro Center	Gallery Pl		Fort Totten		L'Enfant Plaza
let twoLevelStations = [Station.A01,	Station.B01,	Station.B06,	Station.D03,
                        Station.C01,	Station.F01,	Station.E06,	Station.F03]
var timeBefore: NSDate = NSDate(timeIntervalSinceNow: NSTimeInterval(-2))

/**
Gets the stationCode's prediction

- parameter stationCode: the two digit station code
- returns: A JSON containing prediction data, or nil if there was an error
*/
func getPrediction(stationCode: String, onCompleted: (result: JSON?) -> ()) {
	let timeAfter = NSDate()
	
	let secondHalfTwoLevelStations: [Station] = Array(twoLevelStations.split(Station.D03).last!)
	var secondHalfTwoLevelStationCodes: [String] = []
	for station in secondHalfTwoLevelStations {
		secondHalfTwoLevelStationCodes.append(station.rawValue)
	}
	
	// only fetch new predictions if it has been at least one second since they were last fetched or it is the second part of a two level station fetch
	if timeAfter.timeIntervalSinceDate(timeBefore) > 1 || secondHalfTwoLevelStationCodes.contains(stationCode) {
		print("WMATAFetcher: fetching predictions for \((Station(rawValue: stationCode)?.rawValue)!) (\((Station(rawValue: stationCode)?.description)!))")
		
		timeBefore = NSDate()
		
		guard let wmataURL = NSURL(string: "https://api.wmata.com/StationPrediction.svc/json/GetPrediction/" + stationCode) else {
			return
		}
		
		let request = NSMutableURLRequest(URL: wmataURL)
		let session = NSURLSession.sharedSession()
		
		request.setValue("[WMATA_KEY_GOES_HERE]", forHTTPHeaderField:"api_key")
		
		session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) in
			if error == nil {
				let statusCode = (response as! NSHTTPURLResponse).statusCode
				if statusCode == 200 { // success
					onCompleted(result: JSON(data: data!))
				} else { // error
					NSNotificationCenter.defaultCenter().postNotificationName("error", object: nil, userInfo: ["errorString":"Prediction fetch failed (Code: \(statusCode))"])
				}
			} else {
				if error?.code == -1009 {
					NSNotificationCenter.defaultCenter().postNotificationName("error", object: nil, userInfo: ["errorString":"Internet connection is offline"])
				}
			}
		}).resume()
	}
}

func populateTrainArray() {
	trains = []
	
	// the JSON only contains one root element, "Trains"
	predictionJSON = predictionJSON["Trains"]
	
	for (_, subJson): (String, JSON) in predictionJSON {
		var line: Line? = nil
		var min: String? = nil
		var numCars: String? = nil
		var destination: Station? = nil
		
		if subJson["DestinationName"].stringValue == Station.No.description || subJson["DestinationName"].stringValue == Station.Train.description {
			line = Line.NO
			min = subJson["Min"] == nil ? "-" : subJson["Min"].stringValue
			numCars = "-"
			destination = subJson["DestinationName"].stringValue == Station.No.description ? Station.No : Station.Train
		}
		
		if subJson["Min"].stringValue == "" {
			continue
		}
		
		trains.append(Train(numCars: numCars ?? subJson["Car"].stringValue,
			destination: destination ?? Station(rawValue: subJson["DestinationCode"].stringValue)!,
			group: subJson["Group"].stringValue,
			line: line ?? Line(rawValue: subJson["Line"].stringValue)!,
			location: Station(rawValue: subJson["LocationCode"].stringValue)!,
			min: min ?? subJson["Min"].stringValue))
	}
	
	trains.sortInPlace({ $0.group < $1.group })
}

func getPredictionsForSelectedStation() {
	getPrediction(selectedStation.rawValue, onCompleted: {
		result in
		predictionJSON = result!
		populateTrainArray()
		handleTwoLevelStation()
		if trains.count == 0 {
			NSNotificationCenter.defaultCenter().postNotificationName("error", object: nil, userInfo: ["errorString":"No trains are currently arriving"])
		} else {
			NSNotificationCenter.defaultCenter().postNotificationName("reloadTable", object: nil)
		}
	})
}

/**
Checks the selected station to see if it is one of the four metro stations that have two levels.  If it is, fetch the predictions for the second station code, add it to the trains array, and reload the table view.

WMATA API: "Some stations have two platforms (e.g.: Gallery Place, Fort Totten, L'Enfant Plaza, and Metro Center). To retrieve complete predictions for these stations, be sure to pass in both StationCodes.
*/
func handleTwoLevelStation() {
	let stationBefore = selectedStation
	if twoLevelStations.contains(selectedStation) {
		switch selectedStation {
		case Station.A01: selectedStation = Station.C01
		case Station.B01: selectedStation = Station.F01
		case Station.B06: selectedStation = Station.E06
		case Station.D03: selectedStation = Station.F03
		default: break
		}
		
		getPrediction(selectedStation.rawValue, onCompleted: {
			result in
			predictionJSON = result!
			
			let trainsGroup1 = trains
			populateTrainArray()
			trains = trains + trainsGroup1
			
			NSNotificationCenter.defaultCenter().postNotificationName("reloadTable", object: nil)
		})
	}
	selectedStation = stationBefore
}

func getfiveClosestStations(location: CLLocation) -> [Station] {
	var fiveClosestStations = [Station]()
	var distancesDictionary: [CLLocationDistance:String] = [:]
	
	for station in Station.allValues {
		distancesDictionary[station.location.distanceFromLocation(location)] = station.rawValue
	}
	
	let sortedDistancesKeys = Array(distancesDictionary.keys).sort(<)
	
	for (index, key) in sortedDistancesKeys.enumerate() {
		fiveClosestStations.append(Station(rawValue: distancesDictionary[key]!)!)
		if index == 4 {
			break;
		}
	}
	
	return fiveClosestStations
}