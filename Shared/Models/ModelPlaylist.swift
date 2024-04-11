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
class Playlist: Identifiable {
	var id: UUID = UUID()
	var name: String = ""
	var medias: [media] = []
	var m3uLink: String = ""
	
	init(
		_ name: 	String,
		medias:		[media],
		m3uLink: 	String
	) {
		self.name 		= name
		self.medias 	= medias
		self.m3uLink 	= m3uLink
	}
}
