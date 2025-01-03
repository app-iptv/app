//
//  MediasView.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 11/02/2024.
//

import Foundation
import M3UKit
import SDWebImageSwiftUI
import SwiftUI
import TipKit
import XMLTV

struct MediasView: View {
	@AppStorage("MEDIA_DISPLAY_MODE") private var mediaDisplayMode: MediaDisplayMode = .list
	
	@Environment(\.horizontalSizeClass) private var sizeClass
	@Environment(\.isSearching) private var searchState
	@Environment(AppState.self) private var appState
	@Environment(SceneState.self) private var sceneState
	
	@State private var viewModel: MediasViewModel = MediasViewModel()
	
	@Bindable private var playlist: Playlist
	
	internal init(_ playlist: Playlist) {
		self.playlist = playlist
	}
	
	var body: some View {
		Group {
			if mediasForGroup.isEmpty {
				ContentUnavailableView.search(text: viewModel.searchQuery)
			} else /*if mediaDisplayMode == .grid*/ {
//				MediasGridView(vm: viewModel, playlist: playlist)
//			} else {
				MediasListView(vm: viewModel, playlist: playlist)
			}
		}
		.searchable(text: $viewModel.searchQuery, prompt: "Search")
		.navigationDestination(for: Media.self) { MediaDetailView(media: $0) }
		.navigationDestination(for: TVProgram.self) { EPGProgramDetailView(for: $0) }
		.navigationTitle(playlist.name)
		.toolbar(id: "mediasToolbar") { MediasToolbar(groups: groups) }
		#if os(iOS)
		.toolbarRole(sizeClass!.toolbarRole)
		#endif
	}
}

extension MediasView {
	private var searchResults: [Media] { viewModel.searchResults(playlist) }
	private var groups: [String] { viewModel.groups(for: playlist) }
	private var selectedGroup: String { sceneState.selectedGroup }
	private var mediasForGroup: [Media] { viewModel.filteredMediasForGroup(selectedGroup, playlist: playlist) }
}
