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
	
	let playlistName: String
	
	@Binding var favorites: [Playlist.Media]
	
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
		.swipeActions(edge: .leading) { ShareLink(item: media.url, preview: SharePreview(media.name)) }
		.swipeActions(edge: .trailing) { swipeActions }
		.contextMenu { contextMenu }
	}
	
	private var contextMenu: some View {
		VStack {
			ShareLink(item: media.url, preview: SharePreview(media.name))
			Button(favorites.contains(media) ? "Un-favorite" : "Favorite", systemImage: favorites.contains(media) ? "star.slash.fill" : "star", role: favorites.contains(media) ? .destructive : nil) {
				if favorites.contains(media) {
					favorites.remove(at: favorites.firstIndex(of: media)!)
				} else {
					favorites.append(media)
				}
			}
		}
	}
	
	private var swipeActions: some View {
		Button(favorites.contains(media) ? "Un-favorite" : "Favorite", systemImage: favorites.contains(media) ? "star.slash" : "star") {
			if favorites.contains(media) {
				favorites.remove(at: favorites.firstIndex(of: media)!)
			} else {
				favorites.append(media)
			}
		}
		.tint(favorites.contains(media) ? .indigo : .yellow)
	}
}
