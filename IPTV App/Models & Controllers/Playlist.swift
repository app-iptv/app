//
//  Playlist.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 27/01/2024.
//

import Foundation
import M3UKit
import SwiftData
import SwiftUI
import XMLTV

@Model
class Playlist: Identifiable {
	var id: UUID = UUID()
	var name: String = ""
	var medias: [Media] = [Media]()
	var m3uLink: String = ""
	var epgLink: String = ""

	init(
		_ name: String,
		medias: [Media],
		m3uLink: String,
		epgLink: String = ""
	) {
		self.name = name
		self.medias = medias
		self.m3uLink = m3uLink
		self.epgLink = epgLink
	}
}
