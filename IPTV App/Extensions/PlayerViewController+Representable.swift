//
//  PlayerViewController+Representable.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 05/10/2024.
//

import M3UKit

extension PlayerViewController {
	convenience init(media: Media, playlistName: String) {
		self.init(
			name: media.title, url: media.url,
			group: media.attributes["group-title"], playlistName: playlistName)
	}
}

extension PlayerViewControllerRepresentable {
	init(media: Media, playlistName: String) {
		self.init(
			name: media.title, url: media.url,
			group: media.attributes["group-title"], playlistName: playlistName)
	}
}
