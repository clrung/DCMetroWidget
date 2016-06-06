//
//  Line.swift
//  DCMetro
//
//  Created by Christopher Rung on 5/12/16.
//  Copyright © 2016 Christopher Rung. All rights reserved.
//

import Foundation

enum Line : CustomStringConvertible{
    
    case RD, BL, YL, OR, GR, SV, NO
    
    var description : String {
        switch self {
        case .RD: return "Red"
        case .BL: return "Blue"
        case .YL: return "Yellow"
        case .OR: return "Orange"
        case .GR: return "Green"
        case .SV: return "Silver"
        case .NO: return "No Passenger"
        }
    }
    
}