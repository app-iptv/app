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
			.onDelete { indexSet in
				playlist.medias.remove(atOffsets: indexSet)
			}
			.onMove { source, destination in
				playlist.medias.move(fromOffsets: source, toOffset: destination)
			}
		}
		.listStyle(.plain)
	}
}

extension MediasListView {
	private var searchResults: [Media] { viewModel.searchResults(playlist) }
	private var groups: [String] { viewModel.groups(for: playlist) }
	private var selectedGroup: String { appState.selectedGroup }
	private var mediasForGroup: [Media] { viewModel.filteredMediasForGroup(selectedGroup, playlist: playlist) }
}
