//
//  Station.swift
//  DCMetro
//
//  Created by Christopher Rung on 6/9/16.
//  Copyright © 2016 Christopher Rung. All rights reserved.
//

import Foundation

enum Station : CustomStringConvertible {
	
	case A01, A02, A03, A04, A05, A06, A07, A08, A09, A10, A11, A12, A13, A14, A15,
		B01, B02, B03, B04, B05, B06, B07, B08, B09, B10, B11, B35,
		C01, C02, C03, C04, C05, C06, C07, C08, C09, C10, C12, C13, C14, C15,
		D01, D02, D03, D04, D05, D06, D07, D08, D09, D10, D11, D12, D13,
		E01, E02, E03, E04, E05, E06, E07, E08, E09, E10,
		F01, F02, F03, F04, F05, F06, F07, F08, F09, F10, F11,
		G01, G02, G03, G04, G05,
		J02, J03,
		K01, K02, K03, K04, K05, K06, K07, K08,
		N01, N02, N03, N04, N06
	
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
		case C10: return "Ronald Reagan Washington National Airport"
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
		case E01: return "Mt Vernon Sq 7th St-Convention Center"
		case E02: return "Shaw-Howard U"
		case E03: return "U Street/African-Amer Civil War Memorial/Cardozo"
		case E04: return "Columbia Heights"
		case E05: return "Georgia Ave-Petworth"
		case E06: return "Fort Totten"
		case E07: return "West Hyattsville"
		case E08: return "Prince George's Plaza"
		case E09: return "College Park-U of MD"
		case E10: return "Greenbelt"
		case F01: return "Gallery Pl-Chinatown"
		case F02: return "Archives-Navy Memorial-Penn Quarter"
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
		}
	}
	
}