//
//  SearchView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 15/03/2024.
//

import SwiftUI
import SwiftData
import SDWebImageSwiftUI
import M3UKit

struct SearchView: View {
	@Query var modelPlaylists: [ModelPlaylist]
	
	@State var mediaSearchText: String = ""
	
	var allMedias: [Playlist.Media] {
		
		var medias: [Playlist.Media] = []
		
		for playlist in modelPlaylists {
			for media in playlist.medias {
				medias.append(media)
			}
		}
		
		return medias
	}
	
	var filteredMedias: [Playlist.Media] {
		return allMedias.filter { $0.name.localizedCaseInsensitiveContains(mediaSearchText) }
	}
	
    var body: some View {
		NavigationStack {
			ScrollView([.horizontal]) {
				LazyHGrid(rows: [GridItem()]) {
					ForEach(filteredMedias) { media in
						MediaItemView(media: media)
					}
				}.padding()
			}.flipsForRightToLeftLayoutDirection(true)
			.searchable(text: $mediaSearchText)
		}
    }
}

#Preview {
    SearchView()
}
