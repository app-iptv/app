//
//  mediaDetailView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 11/02/2024.
//

import SwiftUI
import M3UKit
import AVKit

struct MediaDetailView: View {
	
	let playlistName: String
	
	let media: Media

	var body: some View {
		ScrollView() {
			VStack(alignment: .leading, spacing: 10) {
				PlayerView(media: media, playlistName: playlistName)
					.aspectRatio(16/9, contentMode: .fit)
					.cornerRadius(10)
				
				VStack(alignment: .leading, spacing: 2.5) {
					if let groupTitle = media.attributes["groupTitle"] {
						Text(groupTitle)
							.font(.footnote)
					}
					Text(media.title)
						.font(.headline)
				}
			}
			.padding()
		}
		.toolbarTitleDisplayMode(.inline)
	}
}
