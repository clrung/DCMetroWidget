//
//  MetroFetcher.swift
//  DCMetro
//
//  Created by Christopher Rung on 5/12/16.
//  Copyright © 2016 Christopher Rung. All rights reserved.
//

import Foundation
import SwiftyJSON

class MetroFetcher {
    
    func getPrediction(stationCode: String) -> Train {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.wmata.com/StationPrediction.svc/json/GetPrediction/" + stationCode)!)
        let session = NSURLSession.sharedSession()

        request.setValue("[WMATA_KEY_GOES_HERE]", forHTTPHeaderField:"api_key")
        
        var train: Train = Train(json: nil)
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error in
            if let jsonData = data {
                let json:JSON = JSON(data: jsonData)
                debugPrint(json)
                train = Train(json: json)
                
                let car = json["Trains"][0]["Car"].intValue
                debugPrint("car value is ", car);
                
                // TODO call notify() on another class when done (other class has to call wait())
                
            } else {
                debugPrint(error)
            }
        })
        
        task.resume()
        
        return train;
    }
    
}