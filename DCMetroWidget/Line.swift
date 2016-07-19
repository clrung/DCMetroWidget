//
//  Line.swift
//  DCMetro
//
//  Created by Christopher Rung on 5/12/16.
//  Copyright © 2016 Christopher Rung. All rights reserved.
//

import Foundation
import Cocoa

enum Line: String {
    
    case RD, BL, YL, OR, GR, SV, NO
    
    var color : NSColor {
        switch self {
        case .RD: return NSColor.redColor()
        case .BL: return NSColor(red: 80/255, green: 150/255, blue: 240/255, alpha: 1)
        case .YL: return NSColor.yellowColor()
        case .OR: return NSColor.orangeColor()
        case .GR: return NSColor(red: 50/255, green: 220/255, blue: 50/255, alpha: 1)
        case .SV: return NSColor(red: 222/255, green: 222/255, blue: 222/255, alpha: 1)
        case .NO: return NSColor.clearColor()
        }
    }
    
}