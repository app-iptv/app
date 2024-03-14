//
//  ViewingOption.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 10/03/2024.
//

import Foundation

enum ViewingOption: CaseIterable, Identifiable {
	case list, grid
	
	var id: Self { self }
}
