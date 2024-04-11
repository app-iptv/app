//
//  mediaRowView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 08/02/2024.
//

import Foundation
import SwiftUI
import M3UKit
import SDWebImageSwiftUI

struct mediaCellView: View {
	
	@AppStorage("FAVORITED_CHANNELS") var favorites: [media] = []
	
	@AppStorage("VIEWING_MODE") var viewingMode: ViewingMode = .regular
	
	let media: media
	
	let playlistName: String
	
	var body: some View {
		HStack {
			WebImage(url: URL(string: media.attributes["tvg-logo"] ?? "")) { image in
				image
					.resizable()
					.scaledToFit()
			} placeholder: {
				Image(systemName: "photo")
			}
			.padding(.trailing, 5)
			.frame(width: viewingMode.photoSize, height: viewingMode.photoSize)
			
			switch viewingMode {
				case .large:
					largeViewingMode
				default:
					otherViewingMode
			}
		}
		.swipeActions(edge: .leading) { ShareLink(item: media.url, preview: SharePreview(media.title)).tint(.pink) }
		.swipeActions(edge: .trailing) { swipeActions }
		.contextMenu { contextMenu }
	}
}

extension mediaCellView {
	private var largeViewingMode: some View {
		VStack(alignment: .leading, spacing: 5) {
			Text(media.title)
				.fontWeight(.semibold)
				.lineLimit(1)
			
			Text(media.attributes["group-title"] ?? "Undefined")
				.font(.caption)
				.lineLimit(1)
		}
	}
	
	private var otherViewingMode: some View {
		HStack {
			Text(media.title)
				.fontWeight(.semibold)
				.lineLimit(1)
			
			Spacer()
			
			Text(media.attributes["group-title"] ?? "Undefined")
				.font(.caption)
				.lineLimit(1)
		}
	}
	
	private var contextMenu: some View {
		VStack {
			ShareLink(item: media.url, preview: SharePreview(media.title))
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
