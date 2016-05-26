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
    
    var car: Int = 0
    var destination: String = ""
    var destinationCode: String = ""
    var destinationName: String = ""
    var Group: String = ""
    var line: Line = Line.NO
    var locationCode: String = ""
    var locationName: String = ""
    var min: Int = 0
    
    required init(json: JSON) {
        
    }
    
}