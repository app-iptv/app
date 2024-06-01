//
//  GuideGroupDetailView.swift
//  IPTV TV App
//
//  Created by Pedro Cordeiro on 19/05/2024.
//

import SwiftUI
import SwiftData
import XMLTV

struct GuideGroupDetailView: View {
	@Query private var modelPlaylists: [Playlist]
	
	@AppStorage("SELECTED_PLAYLIST_INDEX") private var selectedPlaylist: Int = 0
	
	@FocusState private var isFocused: Bool
	
	@State private var vm = ViewModel.shared
	
	private var medias: [Media]
	
	internal init(medias: [Media]) {
		self.medias = medias
	}
	
	var body: some View {
		List(medias) { media in
			NavigationLink {
				GuideForMediaView(media: media)
			} label: {
				MediaCellView(media: media)
			}
		}
    }
}
