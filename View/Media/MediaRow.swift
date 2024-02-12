//
//  MediaRow.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 08/02/2024.
//

import Foundation
import SwiftUI
import AVKit
import M3UKit

struct MediaRow: View {
	
	var media: Playlist.Media
	
	var body: some View {
		HStack {
			AsyncImage(url: URL(string: media.attributes.logo ?? "")) { phase in
				switch phase {
					case .success(let image):
						image
							.resizable()
							.aspectRatio(contentMode: .fit)
							.padding(5)
							.frame(maxWidth: 60, maxHeight: 60)
					default:
						Image(systemName: "photo")
							.frame(width: 60, height: 60)
				}
			}
			.frame(width: 60, height: 60)
			Text(media.name)
				.font(.headline)
			Spacer()
			Text(media.attributes.groupTitle ?? "")
		}
	}
}
