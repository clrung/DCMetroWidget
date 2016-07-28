//
//  Station.swift
//  DCMetro
//
//  Created by Christopher Rung on 6/9/16.
//  Copyright © 2016 Christopher Rung. All rights reserved.
//

import Foundation
import CoreLocation

enum Station: String, CustomStringConvertible {
	
	case A01, A02, A03, A04, A05, A06, A07, A08, A09, A10, A11, A12, A13, A14, A15,
	B01, B02, B03, B04, B05, B06, B07, B08, B09, B10, B11, B35,
	C01, C02, C03, C04, C05, C06, C07, C08, C09, C10, C12, C13, C14, C15,
	D01, D02, D03, D04, D05, D06, D07, D08, D09, D10, D11, D12, D13,
	E01, E02, E03, E04, E05, E06, E07, E08, E09, E10,
	F01, F02, F03, F04, F05, F06, F07, F08, F09, F10, F11,
	G01, G02, G03, G04, G05,
	J02, J03,
	K01, K02, K03, K04, K05, K06, K07, K08,
	N01, N02, N03, N04, N06,
	Train,
	No,
	Space
	
	// facilitates enumeration (Source: http://www.swift-studies.com/blog/2014/6/10/enumerating-enums-in-swift)
	static let allValues = [A01, A02, A03, A04, A05, A06, A07, A08, A09, A10, A11, A12, A13, A14, A15,
	                        B01, B02, B03, B04, B05, B06, B07, B08, B09, B10, B11, B35,
	                        C01, C02, C03, C04, C05, C06, C07, C08, C09, C10, C12, C13, C14, C15,
	                        D01, D02, D03, D04, D05, D06, D07, D08, D09, D10, D11, D12, D13,
	                        E01, E02, E03, E04, E05, E06, E07, E08, E09, E10,
	                        F01, F02, F03, F04, F05, F06, F07, F08, F09, F10, F11,
	                        G01, G02, G03, G04, G05,
	                        J02, J03,
	                        K01, K02, K03, K04, K05, K06, K07, K08,
	                        N01, N02, N03, N04, N06]
	
	var description : String {
		switch self {
		case A01: return "Metro Center"
		case A02: return "Farragut North"
		case A03: return "Dupont Circle"
		case A04: return "Woodley Park-Zoo/Adams Morgan"
		case A05: return "Cleveland Park"
		case A06: return "Van Ness-UDC"
		case A07: return "Tenleytown-AU"
		case A08: return "Friendship Heights"
		case A09: return "Bethesda"
		case A10: return "Medical Center"
		case A11: return "Grosvenor-Strathmore"
		case A12: return "White Flint"
		case A13: return "Twinbrook"
		case A14: return "Rockville"
		case A15: return "Shady Grove"
		case B01: return "Gallery Pl-Chinatown"
		case B02: return "Judiciary Square"
		case B03: return "Union Station"
		case B04: return "Rhode Island Ave-Brentwood"
		case B05: return "Brookland-CUA"
		case B06: return "Fort Totten"
		case B07: return "Takoma"
		case B08: return "Silver Spring"
		case B09: return "Forest Glen"
		case B10: return "Wheaton"
		case B11: return "Glenmont"
		case B35: return "NoMa-Gallaudet U"
		case C01: return "Metro Center"
		case C02: return "McPherson Square"
		case C03: return "Farragut West"
		case C04: return "Foggy Bottom-GWU"
		case C05: return "Rosslyn"
		case C06: return "Arlington Cemetary"
		case C07: return "Pentagon"
		case C08: return "Pentagon City"
		case C09: return "Crystal City"
		case C10: return "Reagan National Airport"
		case C12: return "Braddock Road"
		case C13: return "King St-Old Town"
		case C14: return "Eisenhower Avenue"
		case C15: return "Huntington"
		case D01: return "Federal Triangle"
		case D02: return "Smithsonian"
		case D03: return "L'Enfant Plaza"
		case D04: return "Federal Center SW"
		case D05: return "Capitol South"
		case D06: return "Eastern Market"
		case D07: return "Potomac Ave"
		case D08: return "Stadium-Armory"
		case D09: return "Minnesota Ave"
		case D10: return "Deanwood"
		case D11: return "Cheverly"
		case D12: return "Landover"
		case D13: return "New Carrollton"
		case E01: return "Mt Vernon Sq"
		case E02: return "Shaw-Howard U"
		case E03: return "U Street"
		case E04: return "Columbia Heights"
		case E05: return "Georgia Ave-Petworth"
		case E06: return "Fort Totten"
		case E07: return "West Hyattsville"
		case E08: return "Prince George's Plaza"
		case E09: return "College Park-U of MD"
		case E10: return "Greenbelt"
		case F01: return "Gallery Pl-Chinatown"
		case F02: return "Archives"
		case F03: return "L'Enfant Plaza"
		case F04: return "Waterfront"
		case F05: return "Navy Yard-Ballpark"
		case F06: return "Anacostia"
		case F07: return "Congress Heights"
		case F08: return "Southern Avenue"
		case F09: return "Naylor Road"
		case F10: return "Suitland"
		case F11: return "Branch Ave"
		case G01: return "Benning Road"
		case G02: return "Capitol Heights"
		case G03: return "Addison Road-Seat Pleasant"
		case G04: return "Morgan Boulevard"
		case G05: return "Largo Town Center"
		case J02: return "Van Dorn Street"
		case J03: return "Franconia-Springfield"
		case K01: return "Court House"
		case K02: return "Clarendon"
		case K03: return "Virginia Square-GMU"
		case K04: return "Ballston-MU"
		case K05: return "East Falls Church"
		case K06: return "West Falls Church-UT/UVA"
		case K07: return "Dunn Loring-Merrifield"
		case K08: return "Vienna/Fairfax/GMU"
		case N01: return "McLean"
		case N02: return "Tyson's Corner"
		case N03: return "Greensboro"
		case N04: return "Spring Hill"
		case N06: return "Wiehle-Reston East"
		case Train: return "Train"
		case No: return "No Passenger"
		case Space: return ""
		}
	}
	
	var location: CLLocation {
		switch self {
		case A01: return CLLocation(latitude: 38.898303, longitude: -77.028099)
		case A02: return CLLocation(latitude: 38.903192, longitude: -77.039766)
		case A03: return CLLocation(latitude: 38.909499, longitude: -77.04362)
		case A04: return CLLocation(latitude: 38.924999, longitude: -77.052648)
		case A05: return CLLocation(latitude: 38.934703, longitude: -77.058226)
		case A06: return CLLocation(latitude: 38.94362, longitude: -77.0635110)
		case A07: return CLLocation(latitude: 38.947808, longitude: -77.079615)
		case A08: return CLLocation(latitude: 38.960744, longitude: -77.085969)
		case A09: return CLLocation(latitude: 38.984282, longitude: -77.094431)
		case A10: return CLLocation(latitude: 38.999947, longitude: -77.0972529)
		case A11: return CLLocation(latitude: 39.029158, longitude: -77.10415)
		case A12: return CLLocation(latitude: 39.048043, longitude: -77.113131)
		case A13: return CLLocation(latitude: 39.062359, longitude: -77.1211129)
		case A14: return CLLocation(latitude: 39.084215, longitude: -77.146424)
		case A15: return CLLocation(latitude: 39.119819, longitude: -77.164921)
		case B01: return CLLocation(latitude: 38.89834, longitude: -77.021851)
		case B02: return CLLocation(latitude: 38.896084, longitude: -77.016643)
		case B03: return CLLocation(latitude: 38.897723, longitude: -77.006745)
		case B04: return CLLocation(latitude: 38.920741, longitude: -76.995984)
		case B05: return CLLocation(latitude: 38.933234, longitude: -76.994544)
		case B06: return CLLocation(latitude: 38.951777, longitude: -77.002174)
		case B07: return CLLocation(latitude: 38.975532, longitude: -77.017834)
		case B08: return CLLocation(latitude: 38.993841, longitude: -77.031321)
		case B09: return CLLocation(latitude: 39.015413, longitude: -77.042953)
		case B10: return CLLocation(latitude: 39.038558, longitude: -77.051098)
		case B11: return CLLocation(latitude: 39.061713, longitude: -77.05341)
		case B35: return CLLocation(latitude: 38.907407, longitude: -77.002961)
		case C01: return CLLocation(latitude: 38.898303, longitude: -77.028099)
		case C02: return CLLocation(latitude: 38.901316, longitude: -77.033652)
		case C03: return CLLocation(latitude: 38.901311, longitude: -77.03981)
		case C04: return CLLocation(latitude: 38.900599, longitude: -77.050273)
		case C05: return CLLocation(latitude: 38.896595, longitude: -77.07146)
		case C06: return CLLocation(latitude: 38.884574, longitude: -77.063108)
		case C07: return CLLocation(latitude: 38.869349, longitude: -77.054013)
		case C08: return CLLocation(latitude: 38.863045, longitude: -77.059507)
		case C09: return CLLocation(latitude: 38.85779, longitude: -77.050589)
		case C10: return CLLocation(latitude: 38.852985, longitude: -77.043805)
		case C12: return CLLocation(latitude: 38.814009, longitude: -77.053763)
		case C13: return CLLocation(latitude: 38.806474, longitude: -77.061115)
		case C14: return CLLocation(latitude: 38.800313, longitude: -77.071173)
		case C15: return CLLocation(latitude: 38.793841, longitude: -77.075301)
		case D01: return CLLocation(latitude: 38.893757, longitude: -77.028218)
		case D02: return CLLocation(latitude: 38.888022, longitude: -77.028232)
		case D03: return CLLocation(latitude: 38.884775, longitude: -77.021964)
		case D04: return CLLocation(latitude: 38.884958, longitude: -77.01586)
		case D05: return CLLocation(latitude: 38.884968, longitude: -77.005137)
		case D06: return CLLocation(latitude: 38.884124, longitude: -76.995334)
		case D07: return CLLocation(latitude: 38.880841, longitude: -76.985721)
		case D08: return CLLocation(latitude: 38.88594, longitude: -76.977485)
		case D09: return CLLocation(latitude: 38.898284, longitude: -76.948042)
		case D10: return CLLocation(latitude: 38.907734, longitude: -76.936177)
		case D11: return CLLocation(latitude: 38.91652, longitude: -76.915427)
		case D12: return CLLocation(latitude: 38.934411, longitude: -76.890988)
		case D13: return CLLocation(latitude: 38.947674, longitude: -76.872144)
		case E01: return CLLocation(latitude: 38.905604, longitude: -77.022256)
		case E02: return CLLocation(latitude: 38.912919, longitude: -77.022194)
		case E03: return CLLocation(latitude: 38.916489, longitude: -77.028938)
		case E04: return CLLocation(latitude: 38.928672, longitude: -77.032775)
		case E05: return CLLocation(latitude: 38.936077, longitude: -77.024728)
		case E06: return CLLocation(latitude: 38.951777, longitude: -77.002174)
		case E07: return CLLocation(latitude: 38.954931, longitude: -76.969881)
		case E08: return CLLocation(latitude: 38.965276, longitude: -76.956182)
		case E09: return CLLocation(latitude: 38.978523, longitude: -76.928432)
		case E10: return CLLocation(latitude: 39.011036, longitude: -76.911362)
		case F01: return CLLocation(latitude: 38.89834, longitude: -77.021851)
		case F02: return CLLocation(latitude: 38.893893, longitude: -77.021902)
		case F03: return CLLocation(latitude: 38.884775, longitude: -77.021964)
		case F04: return CLLocation(latitude: 38.876221, longitude: -77.017491)
		case F05: return CLLocation(latitude: 38.876588, longitude: -77.005086)
		case F06: return CLLocation(latitude: 38.862072, longitude: -76.995648)
		case F07: return CLLocation(latitude: 38.845334, longitude: -76.98817)
		case F08: return CLLocation(latitude: 38.840974, longitude: -76.975360)
		case F09: return CLLocation(latitude: 38.851187, longitude: -76.956565)
		case F10: return CLLocation(latitude: 38.843891, longitude: -76.932022)
		case F11: return CLLocation(latitude: 38.826995, longitude: -76.912134)
		case G01: return CLLocation(latitude: 38.890488, longitude: -76.938291)
		case G02: return CLLocation(latitude: 38.889757, longitude: -76.913382)
		case G03: return CLLocation(latitude: 38.886713, longitude: -76.893592)
		case G04: return CLLocation(latitude: 38.8913, longitude: -76.8682)
		case G05: return CLLocation(latitude: 38.9008, longitude: -76.8449)
		case J02: return CLLocation(latitude: 38.799193, longitude: -77.129407)
		case J03: return CLLocation(latitude: 38.766129, longitude: -77.168797)
		case K01: return CLLocation(latitude: 38.891499, longitude: -77.08391)
		case K02: return CLLocation(latitude: 38.886373, longitude: -77.096963)
		case K03: return CLLocation(latitude: 38.88331, longitude: -77.104267)
		case K04: return CLLocation(latitude: 38.882071, longitude: -77.111845)
		case K05: return CLLocation(latitude: 38.885841, longitude: -77.157177)
		case K06: return CLLocation(latitude: 38.90067, longitude: -77.189394)
		case K07: return CLLocation(latitude: 38.883015, longitude: -77.228939)
		case K08: return CLLocation(latitude: 38.877693, longitude: -77.271562)
		case N01: return CLLocation(latitude: 38.924478, longitude: -77.210167)
		case N02: return CLLocation(latitude: 38.920056, longitude: -77.223314)
		case N03: return CLLocation(latitude: 38.919749, longitude: -77.235192)
		case N04: return CLLocation(latitude: 38.92902, longitude: -77.241780)
		case N06: return CLLocation(latitude: 38.947753, longitude: -77.340179)
		case Train: return CLLocation()
		case No: return CLLocation()
		case Space: return CLLocation()
		}
	}
	
}