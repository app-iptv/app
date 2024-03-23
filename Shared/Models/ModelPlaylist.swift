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
final class ModelPlaylist: Identifiable {
	var id: UUID
	var name: String
	var medias: [Playlist.Media]
	var m3uLink: String
	
	init(
		_ id: 		UUID,
		_ name: 	String,
		_ medias: 	[Playlist.Media],
		_ m3uLink: 	String
	) {
		self.id 		= id
		self.name 		= name
		self.medias 	= medias
		self.m3uLink 	= m3uLink
	}
}
