//
//  MediaRowView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 08/02/2024.
//

import Foundation
import SwiftUI
import M3UKit
import SDWebImageSwiftUI

struct MediaCellView: View {
	
	let media: Playlist.Media
	
	#if DEBUG
	init(media: Playlist.Media) {
		print("Loading media: \(media.name)")
		self.media = media
	}
	#endif
	
	var body: some View {
		HStack {
			WebImage(url: URL(string: media.attributes.logo ?? "")) { image in
				image
					.resizable()
					.scaledToFit()
			} placeholder: {
				Image(systemName: "photo")
			}
			.padding(.trailing, 5)
			.frame(width: 60, height: 60)
			Text(media.name)
				.lineLimit(1)
				.font(.headline)
			Spacer()
			Text(media.attributes.groupTitle ?? "")
				.font(.footnote)
				.lineLimit(1)
		}
	}
}
