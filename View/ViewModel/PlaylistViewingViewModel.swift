//
//  PlaylistViewingViewModel.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 07/02/2024.
//

import Foundation
import SwiftUI

enum SortingOption: CaseIterable, Identifiable {
	case country, alphabetical, language, kind, normal
	
	var id: Self { self }
	
	var label: some View {
		switch self {
		case .alphabetical:
			Label("Alphabetical", systemImage: "textformat")
		case .country:
			Label("Country", systemImage: "globe.europe.africa")
		case .kind:
			Label("Kind", systemImage: "line.horizontal.3.decrease.circle")
		case .language:
			Label("Language", systemImage: "bubble.left.and.text.bubble.right")
		case .normal:
			Label("Default", systemImage: "list.bullet")
		}
	}
}

enum ViewingOption: CaseIterable {
	case list, table
	
	var id: Self { self }
	
	var label: some View {
		switch self {
		case .list:
			Label("List", systemImage: "list.bullet")
		case .table:
			Label("Table", systemImage: "table")
		}
	}
}
