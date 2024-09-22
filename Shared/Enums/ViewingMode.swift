//
//  ViewingMode.swift
//  IPTV
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
		case .large:
			return "Large"
		case .regular:
			return "Regular"
		case .compact:
			return "Compact"
		}
	}

	var logo: String {
		switch self {
		case .large:
			return "square.fill.text.grid.1x2"
		case .regular:
			return "rectangle.grid.1x2"
		case .compact:
			return "list.dash"
		}
	}

	var photoSize: CGFloat {
		switch self {
		case .large:
			return 70
		case .regular:
			return 50
		case .compact:
			return 30
		}
	}

	var label: some View {
		Text(self.name)
	}
}
