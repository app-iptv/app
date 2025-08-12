//
//  PlaylistsToolbar.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 15/12/2024.
//

import SwiftUI

struct PlaylistsToolbar: CustomizableToolbarContent {
	@Environment(AppState.self) var appState
	
	var body: some CustomizableToolbarContent {
		ToolbarItem(id: "addPlaylist") {
			Button("Add Playlist", systemImage: "plus") {
				appState.isAddingPlaylist.toggle()
			}
		}

		ToolbarItem(id: "openSingleStream") {
			Button("Open Stream", systemImage: "play") {
				appState.openedSingleStream.toggle()
			}
		}
	}
}

extension PlaylistsToolbar {
	var placement: ToolbarItemPlacement {
		#if os(macOS)
		return .automatic
		#else
		return .topBarLeading
		#endif
	}
}
