//
//  MediasGridView.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 12/12/2024.
//

import SwiftUI

struct MediasGridView: View {
	@Environment(AppState.self) var appState
	@Environment(SceneState.self) var sceneState
	
	@Bindable var viewModel: MediasViewModel
	@Bindable var playlist: Playlist
	
	let columns = [
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
	var groups: [String] { viewModel.groups(for: medias) }
	var selectedGroup: String { sceneState.selectedGroup }
	var mediasForGroup: [Media] { viewModel.filteredMediasForGroup(selectedGroup, medias: medias) }
	
	var medias: [Media] { playlist.medias }
}

