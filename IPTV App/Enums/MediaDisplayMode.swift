//
//  MediaDisplayMode.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 24/08/2024.
//

import Foundation
import SwiftUI

enum MediaDisplayMode: String, CaseIterable, Identifiable {
	case list = "list"
	case grid = "grid"

	var id: Self { self }

	var name: LocalizedStringKey {
		switch self {
			case .list: "List"
			case .grid: "Grid"
		}
	}

	var systemImage: String {
		switch self {
			case .list: "rectangle.grid.1x2"
			case .grid: "rectangle.grid.2x2"
		}
	}

	var label: Label<Text, Image> {
		Label(name, systemImage: systemImage)
	}
}
