//
//  GuideView.swift
//  IPTV TV App
//
//  Created by Pedro Cordeiro on 19/05/2024.
//

import SwiftUI
import SwiftData

struct GuideView: View {
	@Query private var modelPlaylists: [Playlist]
	
	var body: some View {
		NavigationStack {
			List(modelPlaylists) { playlist in
				GuidePlaylistsGroupView(playlist: playlist)
			}
		}
    }
}
