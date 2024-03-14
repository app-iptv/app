//
//  MediaDetailView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 11/02/2024.
//

import SwiftUI
import M3UKit

struct MediaDetailView: View {
	
	let playlistName: String
	
	let media: Playlist.Media?
		
	var body: some View {
		ScrollView() {
			VStack(alignment: .leading, spacing: 10) {
				PlayerView(media: media, playlistName: playlistName)
					.aspectRatio(16/9, contentMode: .fit)
					.cornerRadius(10)
				
				VStack(alignment: .leading, spacing: 2.5) {
					Text(media!.attributes.groupTitle!)
						.font(.footnote)
					Text(media!.name)
						.font(.headline)
				}
			}
			.padding()
		}
		.navigationBarTitleDisplayMode(.inline)
	}
}
