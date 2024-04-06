//
//  ViewingMode.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 31/03/2024.
//

import Foundation
import SwiftUI

enum ViewingMode: CaseIterable, Identifiable, RawRepresentable {
	case compact, regular, large
	
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
	
	typealias RawValue = String
	
	init?(rawValue: RawValue) {
		switch rawValue {
			case "large":
				self = .large
			case "regular":
				self = .regular
			case "compact":
				self = .compact
			default:
				return nil
		}
	}
	
	var rawValue: RawValue {
		switch self {
			case .large:
				return "large"
			case .regular:
				return "regular"
			case .compact:
				return "compact"
		}
	}
}
