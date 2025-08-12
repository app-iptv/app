//
//  PlaylistsView.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 12/08/2025.
//

import SwiftUI
import SwiftData

struct PlaylistsView: View {
	@Environment(\.modelContext) var context
	@Environment(AppState.self) var appState
	@Environment(SceneState.self) var sceneState
	
	@Query var playlists: [Playlist]
	
	var body: some View {
		@Bindable var sceneState = self.sceneState
		
		NavigationStack {
			List(playlists) { playlist in
				NavigationLink(playlist.name, value: MediaTab.playlist(playlist))
					.swipeActions {
						Button("Delete", systemImage: "trash", role: .destructive) {
							context.delete(playlist)
						}
						.labelStyle(.iconOnly)
					}
			}
			.navigationTitle("Playlists")
			.toolbar { PlaylistsToolbar() }
			.navigationDestination(for: MediaTab.self) { tab in
				switch tab {
					case .playlist(let playlist):
						MediasView(playlist)
							.onAppear { sceneState.selectedTab = .playlist(playlist) }
					default: EmptyView()
				}
			}
		}
	}
}

#Preview {
	PlaylistsView()
}
