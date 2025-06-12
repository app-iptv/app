//
//  PreviewPlaylist.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 11/06/2025.
//

import Foundation

extension Playlist {
	static var preview: Playlist {
		Playlist(
			"Extended Playlist",
			medias: (1...50).map {
				Media(
					title: "Channel \($0)",
					duration: -1,
					attributes: [
						"tvg-id": "channel\($0).id",
						"group-title": ["News", "Movies", "Music", "Sports", "Kids"].randomElement()!
					],
					url: "http://stream.example.com/channel\($0).m3u8"
				)
			},
			m3uLink: "http://example.com/playlist.m3u",
			epgLink: "http://example.com/epg.xml"
		)
	}
}
