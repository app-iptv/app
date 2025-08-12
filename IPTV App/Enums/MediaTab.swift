//
//  MediaTab.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 11/08/2025.
//

import Foundation

enum MediaTab: Hashable {
	case favourites
	case settings
	case search
	case playlists
	case playlist(Playlist)
	
	var title: String {
		switch self {
			case .favourites: return String(localized: "Favourites")
			case .settings: return String(localized: "Settings")
			case .search: return String(localized: "Search")
			case .playlists: return String(localized: "Playlists")
			case .playlist(let playlist): return playlist.name
		}
	}
	
	var systemImage: String {
		switch self {
			case .favourites: return "star"
			case .settings: return "gear"
			case .search: return "magnifyingglass"
			case .playlists: return "film.stack"
			case .playlist: return "film.stack"
		}
	}
}
