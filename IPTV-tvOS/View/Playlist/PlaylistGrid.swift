//
//  PlaylistGrid.swift
//  IPTV-tvOS
//
//  Created by Pedro Cordeiro on 22/02/2024.
//

import SwiftUI
import SwiftData
import M3UKit

struct PlaylistGrid: View {
	
	@Query var savedPlaylists: [SavedPlaylist]
	
	var filteredMedias: [String: Playlist.Media] = [:]
	
	let layout = [GridItem(.fixed(40))]
	
	var body: some View {
		ScrollView(.horizontal) {
			LazyHStack {
				
			}
		}
		.navigationDestination(for: SavedPlaylist.self) { playlist in
			MediaGrid(playlist: playlist)
		}
	}
}
