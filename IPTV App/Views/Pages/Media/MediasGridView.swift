//
//  MediasGridView.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 12/12/2024.
//

import SwiftUI

struct MediasGridView: View {
	@Environment(AppState.self) private var appState
	@Environment(SceneState.self) private var sceneState
	
	@Bindable private var viewModel: MediasViewModel
	@Bindable private var playlist: Playlist
	
	private let columns = [
		GridItem(.adaptive(minimum: 80))
	]
	
	internal init(vm viewModel: MediasViewModel, playlist: Playlist) {
		self.viewModel = viewModel
		self.playlist = playlist
	}
	
	var body: some View {
		ScrollView {
			LazyVGrid(columns: columns) {
				ForEach(mediasForGroup) { media in
					NavigationLink(value: media) {
						MediaGridItemView(media: media, index: playlist.medias.firstIndex(of: media)! + 1)
					}
				}
			}
		}
	}
}

extension MediasGridView {
	private var searchResults: [Media] { viewModel.searchResults(playlist) }
	private var groups: [String] { viewModel.groups(for: playlist) }
	private var selectedGroup: String { sceneState.selectedGroup }
	private var mediasForGroup: [Media] { viewModel.filteredMediasForGroup(selectedGroup, playlist: playlist) }
}

