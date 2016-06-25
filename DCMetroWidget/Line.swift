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
        case .BL: return NSColor.blueColor()
        case .YL: return NSColor.yellowColor()
        case .OR: return NSColor.orangeColor()
        case .GR: return NSColor.greenColor()
        case .SV: return NSColor.grayColor()
        case .NO: return NSColor.clearColor()
        }
    }
    
}