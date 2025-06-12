//
//  MediasListView.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 17/11/2024.
//

import SwiftUI
import TipKit

struct MediasListView: View {
	@Environment(AppState.self) private var appState
	@Environment(SceneState.self) private var sceneState
	
	@Bindable private var viewModel: MediasViewModel
	@Bindable private var playlist: Playlist
	
	internal init(vm viewModel: MediasViewModel, playlist: Playlist) {
		self.viewModel = viewModel
		self.playlist = playlist
	}
	
	var body: some View {
		List {
			TipView(viewModel.favouritesTip)
				.task { await FavouritesTip.showTipEvent.donate() }

			ForEach(mediasForGroup) { media in
				NavigationLink(value: media) {
					MediaCellView(media: media)
				}
				.badge(playlist.medias.firstIndex(of: media)! + 1)
			}
			.onDelete { playlist.medias.remove(atOffsets: $0) }
			.onMove { playlist.medias.move(fromOffsets: $0, toOffset: $1) }
		}
		.listStyle(.plain)
	}
}

extension MediasListView {
	private var searchResults: [Media] { viewModel.searchResults(medias) }
	private var groups: [String] { viewModel.groups(for: medias) }
	private var selectedGroup: String { sceneState.selectedGroup }
	private var mediasForGroup: [Media] { viewModel.filteredMediasForGroup(selectedGroup, medias: medias) }
	
	private var medias: [Media] { playlist.medias }
}
