//
//  Tab.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 14/04/2024.
//

import SwiftUI

enum Tab: String, CaseIterable {
	case home, tv, guide, movies, search, favourites, settings

	var fillImage: String {
		switch self {
			case .favourites: "star.fill"
			case .home: "play.house.fill"
			case .settings: "gear"
			case .guide: "list.bullet.below.rectangle"
			case .movies: "movieclapper.fill"
			case .search: "magnifyingglass"
			case .tv: "play.tv.fill"
		}
	}

	var nonFillImage: String {
		switch self {
			case .favourites: "star"
			case .home: "play.house"
			case .settings: "gear"
			case .guide: "list.bullet.below.rectangle"
			case .movies: "movieclapper"
			case .search: "magnifyingglass"
			case .tv:"play.tv"
		}
	}

	var name: LocalizedStringKey {
		switch self {
			case .favourites: "Favourites"
			case .home: "Home"
			case .settings: "Settings"
			case .guide: "Guide"
			case .movies: "Movies & Series"
			case .search: "Search"
			case .tv: "TV"
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
		case "guide":
			self = .guide
		case "movies":
			self = .movies
		case "search":
			self = .search
		case "tv":
			self = .tv
		default:
			return nil
		}
	}

	var rawValue: RawValue {
		switch self {
			case .favourites: "favourites"
			case .home: "home"
			case .settings: "settings"
			case .guide: "guide"
			case .movies: "movies"
			case .search: "search"
			case .tv: "tv"
		}
	}
}
