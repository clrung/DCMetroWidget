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

class TodayViewController: NSViewController, NCWidgetProviding, NSTableViewDelegate, NSTableViewDataSource {
    
    @IBOutlet weak var predictionTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var predictionTableView: NSTableView!
    var prediction: JSON = JSON(NSNull)
    var trains:[Train] = []
    
    let HEADER_HEIGHT = 23
    let ROW_HEIGHT = 17
    let ROW_SPACING = 6
    
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
        
        let train1 = Train(json: nil)
        train1.line = Line.BL
        train1.min = 1
        train1.numCars = 6
        train1.destination = "Largo Town Center"
        
        let train2 = Train(json: nil)
        train2.line = Line.GR
        train2.min = 2
        train2.numCars = 4
        train2.destination = "Franconia-Springfield"
        
        let train3 = Train(json: nil)
        train3.line = Line.OR
        train3.min = 3
        train3.numCars = 6
        train3.destination = "Wiehle-Reston East"
        
        trains = [train1, train2, train3];
        
        self.predictionTableViewHeightConstraint.constant = CGFloat(HEADER_HEIGHT + trains.count * (ROW_HEIGHT + ROW_SPACING))

        self.predictionTableView.reloadData()
        
        debugPrint("beginning fetch")
        // TODO start a progress indicator
        
        getPrediction("B03", onCompleted: {
            debugPrint("fetch completed")
            // TODO stop a progress indicator
        })
        
    }
    
    var widgetAllowsEditing: Bool {
        return true
    }
    
    func widgetDidBeginEditing() {
        debugPrint("began editing")
    }
    
    func widgetDidEndEditing() {
        debugPrint("ended editing in main")
    }
    
    func getPrediction(stationCode: String, onCompleted: () -> ()) {
        guard let wmataURL = NSURL(string: "https://api.wmata.com/StationPrediction.svc/json/GetPrediction/" + stationCode) else {
            debugPrint("Error: cannot create URL")
            return
        }
        
        let request = NSMutableURLRequest(URL: wmataURL)
        let session = NSURLSession.sharedSession()
        
        request.setValue("[WMATA_KEY_GOES_HERE]", forHTTPHeaderField:"api_key")
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) in
            if error == nil {
                self.prediction = JSON(data: data!)
                
                debugPrint(self.prediction)
                
                onCompleted()
            } else {
                debugPrint(error)
            }
        })
        
        task.resume()
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return trains.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let item = trains[row]
        
        var lineColor:NSImage?
        
        var text = ""
        var cellIdentifier: String = ""

        if tableColumn == tableView.tableColumns[0] {
            cellIdentifier = "lineCell"
            text = item.line.description
        } else if tableColumn == tableView.tableColumns[1] {
            cellIdentifier = "timeCell"
            text = String(item.min)
        } else if tableColumn == tableView.tableColumns[2] {
            cellIdentifier = "carsCell"
            text = String(item.numCars)
        } else if tableColumn == tableView.tableColumns[3] {
            cellIdentifier = "destinationCell"
            text = item.destination
        }

        if let cell = tableView.makeViewWithIdentifier(cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            cell.imageView?.image = lineColor ?? nil
            return cell
        }
        
        return nil
    }
    
}