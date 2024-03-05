//
//  MediaGrid.swift
//  IPTV-tvOS
//
//  Created by Pedro Cordeiro on 22/02/2024.
//

import SwiftUI
import M3UKit

struct MediaGrid: View {
	
	var playlist: SavedPlaylist
	
	@State var groupedMedia: [String: [Playlist.Media]] = [:]
	
	// Call this method whenever your media list updates
	func updateGroupedMedia() {
		DispatchQueue.global(qos: .userInitiated).async {
			let newGroupedMedia = Dictionary(grouping: self.playlist.playlist?.medias ?? []) { $0.attributes.groupTitle ?? "Ungrouped" }
			
			DispatchQueue.main.async {
				self.groupedMedia = newGroupedMedia
				// Ensure "All" is handled correctly if needed
			}
		}
	}
	
	var body: some View {
		ScrollView {
			LazyVStack {
				ForEach(Array(groupedMedia.keys.sorted()), id: \.self) { group in
					VStack(alignment: .leading) {
						Text(group)
						ScrollView(.horizontal) {
							LazyHStack {
								if let medias = groupedMedia[group], !medias.isEmpty {
									ForEach(medias, id: \.self) { media in
										MediaCell(media: media)
									}
								}
							}
						}
					}
				}
			}
		}
		.onAppear {
			updateGroupedMedia()
		}
	}
}
