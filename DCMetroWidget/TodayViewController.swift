//
//  TodayViewController.swift
//  DCMetroWidget
//
//  Created by Christopher Rung on 4/27/16.
//  Copyright © 2016 Christopher Rung. All rights reserved.
//

import Cocoa
import NotificationCenter

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
        
        let fetcher: MetroFetcher = MetroFetcher()
        
        fetcher.getPrediction("B03")
        
    }

}


