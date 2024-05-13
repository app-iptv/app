//
//  Tab.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 14/04/2024.
//

import SwiftUI

enum Tab: String, CaseIterable {
	case favourites
	case home
	case settings
	
	var fillImage: String {
		switch self {
			case .favourites:
				"star.fill"
			case .home:
				"play.fill"
			case .settings:
				"gearshape.fill"
		}
	}
	
	var nonFillImage: String {
		switch self {
			case .favourites:
				"star"
			case .home:
				"play"
			case .settings:
				"gearshape"
		}
	}
	
	var name: LocalizedStringKey {
		switch self {
			case .favourites:
				"Favourites"
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
			case "favourites":
				self = .favourites
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
			case .favourites:
				return "favourites"
			case .home:
				return "home"
			case .settings:
				return "settings"
		}
	}
}
