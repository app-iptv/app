//
//  FavoritesView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 19/03/2024.
//

import SwiftUI
import M3UKit

struct FavoritesView: View {
	
	@Binding var favorites: [Playlist.Media]
	
	var filteredFavorites: [Playlist.Media] {
		guard !searchQuery.isEmpty else { return favorites }
		return favorites.filter { $0.name.localizedCaseInsensitiveContains(searchQuery) || $0.attributes.groupTitle!.localizedStandardContains(searchQuery) }
	}
	
	@State private var isDeletingAll: Bool = false
	
	@State private var searchQuery: String = ""
	
    var body: some View {
		NavigationStack {
			Group {
				if favorites.isEmpty {
					ContentUnavailableView {
						Label("No Favorited Medias", systemImage: "star.slash")
					} description: {
						Text("The medias you favorite will appear here. To add some favorites, click on the star symbol next to a media.")
					}
				} else if filteredFavorites.isEmpty {
					ContentUnavailableView.search(text: searchQuery)
				} else {
					List(filteredFavorites) { media in
						NavigationLink(value: media) {
							MediaCellView(media: media, playlistName: "Favorites", favorites: $favorites)
						}
					}
					.id(UUID())
					.listStyle(.plain)
				}
			}
			.navigationTitle("Favorites")
			.searchable(text: $searchQuery, prompt: "Search Favorites")
			.navigationDestination(for: Playlist.Media.self) { media in
				MediaDetailView(playlistName: "Favorites", media: media)
			}
			.confirmationDialog("Delete All Favorited Medias?", isPresented: $isDeletingAll) {
				Button("Cancel", systemImage: "xmark.circle", role: .cancel) { isDeletingAll.toggle() }
				Button("DELETE ALL", systemImage: "trash", role: .destructive) { favorites.removeAll() }
			} message: {
				Text("WARNING: You are about to delete all favorited medias. If you have deleted the source playlist for a media, you will have to add the playlist again to reclaim it.")
			}
		}
    }
}
