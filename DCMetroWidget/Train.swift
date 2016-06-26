//
//  Train.swift
//  DCMetro
//
//  Created by Christopher Rung on 5/12/16.
//  Copyright © 2016 Christopher Rung. All rights reserved.
//

import Foundation
import SwiftyJSON

/**
Based on WMATA's definition of IMPredictionTrainInfo, found here: https://developer.wmata.com/docs/services/547636a6f9182302184cda78/operations/547636a6f918230da855363f/console#AIMPredictionTrainInfo
*/
class Train {
	
	var numCars: String = ""
	var destination: Station = Station.A01
	var group: String = ""
	var line: Line = Line.NO
	var location: Station = Station.A01
	var min: String = "0"
	
	required init(numCars: String, destination: Station, group: String, line: Line, location: Station, min: String ) {
		self.numCars = numCars
		self.destination = destination
		self.group = group
		self.line = line
		self.location = location
		self.min = min
	}
	
	var debugDescription: String {
		return "numCars: \(numCars)   " +
		"destination: \(destination.description)   " +
		"group: \(group)   " +
		"line: \(line.rawValue)   " +
		"location: \(location.description)   " +
		"min: \(min)"
	}
	
}