//
//  MediaCell.swift
//  IPTV-tvOS
//
//  Created by Pedro Cordeiro on 22/02/2024.
//

import SwiftUI
import M3UKit

struct MediaCell: View {
	
	var media: Playlist.Media
	
	var body: some View {
		LazyVStack {
			AsyncImage(url: URL(string: media.attributes.logo ?? "")) { phase in
				switch phase {
					case .success(let image):
						image
							.resizable()
							.aspectRatio(contentMode: .fit)
					default:
						Image(systemName: "photo")
				}
			}
			.frame(width: 150, height: 150)
			.padding()
			Text(media.name)
		}
		.frame(width: 300, height: 300)
	}
}
