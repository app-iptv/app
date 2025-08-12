//
//  SearchView.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 12/08/2025.
//

import SwiftUI
import SwiftData

struct SearchView: View {
	@Query var playlists: [Playlist]
	
	var allMedias: [(Media, String)] {
		playlists.flatMap { playlist in
			playlist.medias.map { media in
				(media, playlist.epgLink)
			}
		}
	}
	
	var body: some View {
		/*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
	}
}
