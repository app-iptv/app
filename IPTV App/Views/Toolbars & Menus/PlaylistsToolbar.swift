//
//  PlaylistsToolbar.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 15/12/2024.
//

import SwiftUI

struct PlaylistsToolbar: CustomizableToolbarContent {
	@Environment(AppState.self) private var appState
	
	private var main: Bool
	
	internal init(main: Bool) { self.main = main }
	
	var body: some CustomizableToolbarContent {
		if !main {
			ToolbarItem(id: "addPlaylist") {
				Button("Add Playlist", systemImage: "plus") {
					appState.isAddingPlaylist.toggle()
				}
			}
		}

		ToolbarItem(id: "openSingleStream", placement: main ? placement : .automatic) {
			Button("Open Stream", systemImage: "play") {
				appState.openedSingleStream.toggle()
			}
		}
	}
}

extension PlaylistsToolbar {
	private var placement: ToolbarItemPlacement {
		#if os(macOS)
		return .automatic
		#else
		return .topBarLeading
		#endif
	}
}
