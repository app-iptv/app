//
//  ViewingMode.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 31/03/2024.
//

import Foundation
import SwiftUI

enum ViewingMode: String, CaseIterable, Identifiable {
	case compact = "compact"
	case regular = "regular"
	case large = "large"

	var id: Self { self }

	var name: LocalizedStringKey {
		switch self {
			case .large: "Large"
			case .regular: "Regular"
			case .compact: "Compact"
		}
	}

	var logo: String {
		switch self {
			case .large: "square.fill.text.grid.1x2"
			case .regular: "rectangle.grid.1x2"
			case .compact: "list.dash"
		}
	}

	var photoSize: CGFloat {
		switch self {
			case .large: 70
			case .regular: 50
			case .compact: 30
		}
	}

	var label: Text {
		Text(self.name)
	}
}
