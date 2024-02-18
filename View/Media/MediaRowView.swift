//
//  MediaRowView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 08/02/2024.
//

import Foundation
import SwiftUI
import M3UKit

struct MediaRowView: View {
	
	var media: Playlist.Media
	
	var body: some View {
		LazyVStack {
			HStack {
				AsyncImage(url: URL(string: media.attributes.logo ?? "")) { phase in
					switch phase {
						case .success(let image):
							image
								.resizable()
								.aspectRatio(contentMode: .fit)
								.frame(maxWidth: 60, maxHeight: 60)
								.padding(.trailing, 5)
						default:
							Image(systemName: "photo")
								.frame(width: 60, height: 60)
					}
				}
				#if !os(macOS)
				.frame(width: 60, height: 60)
				#else
				.frame(width: 40, height: 40)
				#endif
				Text(media.name)
					.lineLimit(1)
					.font(.headline)
				Spacer()
				Text(media.attributes.groupTitle ?? "")
					.lineLimit(1)
				#if !os(macOS)
					.font(.footnote)
				#endif
			}
		}
	}
}
