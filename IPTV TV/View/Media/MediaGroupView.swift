//
//  MediaGroupView.swift
//  IPTV TV
//
//  Created by Pedro Cordeiro on 14/03/2024.
//

import Foundation
import SwiftUI
import M3UKit

struct MediaGroupView: View {
	let groupTitle: String
	let medias: [Playlist.Media]
	
	var body: some View {
		VStack(alignment: .leading) {
			Text(groupTitle)
				.font(.footnote)
				.padding(.bottom, 8)
			ScrollView([.horizontal]) {
				LazyHGrid(rows: [GridItem()]) {
					ForEach(medias, id: \.self) { media in
						MediaItemView(media: media)
					}
				}.padding()
			}.flipsForRightToLeftLayoutDirection(true)
		}
		.padding()
	}
}
