//
//  SearchView.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 12/08/2025.
//

import SwiftUI
import SwiftData

struct SearchView: View {
	@Environment(AppState.self) var appState
	@Environment(EPGFetchingController.self) var controller
	
	@Query var playlists: [Playlist]
	
	@State var searchQuery: String = ""
	
	var allMedias: [(Media, String)] {
		playlists.flatMap { playlist in
			playlist.medias.map { ($0, playlist.epgLink) }
		}
	}
	
	var searchResult: [(Media, String)] {
		return allMedias.filter { media, _ in
			media.title.localizedCaseInsensitiveContains(searchQuery)
		}
	}
	
	var body: some View {
		NavigationStack {
			Group {
				if allMedias.isEmpty {
					ContentUnavailableView("No Playlists", systemImage: "list.and.film", description: Text("You haven't added any playlists. Add one before searching through the medias."))
				} else if searchResult.isEmpty {
					ContentUnavailableView.search(text: searchQuery)
				} else {
					List(searchResult, id: \.0.id) { media, epg in
						let mediaWithEPG = MediaWithEPG(media: media, epg: epg)
						
						NavigationLink(value: mediaWithEPG) {
							MediaCellView(media: media)
						}
					}
				}
			}
			.navigationDestination(for: MediaWithEPG.self) { mediaWithEPG in
				MediaDetailView(media: mediaWithEPG.media)
					.task { await controller.load(epg: mediaWithEPG.epg, appState: appState) }
			}
			.searchable(text: $searchQuery)
		}
	}
	
	struct MediaWithEPG: Hashable {
		var media: Media
		var epg: String
	}
}
