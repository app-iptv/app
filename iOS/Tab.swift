//
//  Tab.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 14/04/2024.
//

import Foundation

enum Tab: String, CaseIterable {
	case favorites
	case home
	case settings
	
	var fillImage: String {
		switch self {
			case .favorites:
				"star.fill"
			case .home:
				"play.fill"
			case .settings:
				"gearshape.fill"
		}
	}
	
	var nonFillImage: String {
		switch self {
			case .favorites:
				"star"
			case .home:
				"play"
			case .settings:
				"gearshape"
		}
	}
	
	var name: String {
		switch self {
			case .favorites:
				"Favorites"
			case .home:
				"Home"
			case .settings:
				"Settings"
		}
	}
}

extension Tab: RawRepresentable {
	typealias RawValue = String
	
	init?(rawValue: RawValue) {
		switch rawValue {
			case "favorites":
				self = .favorites
			case "home":
				self = .home
			case "settings":
				self = .settings
			default:
				return nil
		}
	}
	
	var rawValue: RawValue {
		switch self {
			case .favorites:
				return "favorites"
			case .home:
				return "home"
			case .settings:
				return "settings"
		}
	}
}
