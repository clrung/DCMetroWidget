//
//  TodayViewController.swift
//  DCMetroWidget
//
//  Created by Christopher Rung on 4/27/16.
//  Copyright © 2016 Christopher Rung. All rights reserved.
//

import Cocoa
import NotificationCenter
import SwiftyJSON

class TodayViewController: NSViewController, NCWidgetProviding {
    
    override var nibName: String? {
        return "TodayViewController"
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Update your data and prepare for a snapshot. Call completion handler when you are done
        // with NoData if nothing has changed or NewData if there is new data since the last
        // time we called you
        completionHandler(.NoData)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        debugPrint("beginning fetch")
        // TODO start a progress indicator
        
        getPrediction("B03", onCompleted: {
            debugPrint("fetch completed")
            // TODO stop a progress indicator
        })
        
    }
    
    func getPrediction(stationCode: String, onCompleted: () -> ()) {
        guard let wmataURL = NSURL(string: "https://api.wmata.com/StationPrediction.svc/json/GetPrediction/" + stationCode) else {
            debugPrint("Error: cannot create URL")
            return
        }
        
        let request = NSMutableURLRequest(URL: wmataURL)
        let session = NSURLSession.sharedSession()
        
        request.setValue("[WMATA_KEY_GOES_HERE]", forHTTPHeaderField:"api_key")
        
        var prediction: JSON = JSON(NSNull)
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            if error != nil {
                prediction = JSON(data: data!)
                
                debugPrint(prediction)
                
                let firstCar = prediction["Trains"][0]["Car"].intValue
                debugPrint("car value is ", firstCar)
                
                onCompleted()
            } else {
                debugPrint(error)
            }
        })
        
        task.resume()
    }
    
}