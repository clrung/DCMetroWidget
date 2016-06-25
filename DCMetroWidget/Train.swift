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
    
    var numCars: Int = 0
    var destination: Station = Station.A01
    var group: Int = 0
    var line: Line = Line.NO
    var location: Station = Station.A01
    var min: Int = 0
    
	required init(numCars: Int, destination: Station, group: Int, line: Line, location: Station, min: Int ) {
        self.numCars = numCars
		self.destination = destination
		self.group = group
		self.line = line
		self.location = location
		self.min = min
    }
    
}