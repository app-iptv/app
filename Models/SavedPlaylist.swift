//
//  PlaylistsViewModel.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 27/01/2024.
//

import SwiftUI
import M3UKit
import SwiftData
import Foundation

@Model
final class SavedPlaylist: Identifiable {
	@Attribute(.unique) var id: UUID
	@Attribute(.spotlight) var name: String
	var playlist: Playlist?
	var m3uLink: String
	
	init(
		id: UUID,
		name: String,
		playlist: Playlist? = nil,
		m3uLink: String
	) {
		self.id 		= id
		self.name 		= name
		self.playlist 	= playlist
		self.m3uLink 	= m3uLink
	}
}
