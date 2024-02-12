//
//  MediaDetailView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 11/02/2024.
//

import SwiftUI
import M3UKit

struct MediaDetailView: View {
	
#if os(macOS)
	@Binding var selectedMedia: Playlist.Media?
#else
	@State var selectedMedia: Playlist.Media?
#endif
	
	var body: some View {
		ScrollView() {
			VStack(alignment: .leading, spacing: 10) {
				PlayerView(media: $selectedMedia)
					.aspectRatio(16/9, contentMode: .fit)
					.cornerRadius(10)
				VStack(alignment: .leading, spacing: 2.5) {
					Text(selectedMedia?.attributes.groupTitle ?? "")
						.font(.footnote)
					Text(selectedMedia?.name ?? "")
						.font(.headline)
				}
			}
			.padding()
			#if os(iOS)
			#endif
		}
		#if !os(macOS)
		.navigationBarTitleDisplayMode(.inline)
		#endif
	}
}
