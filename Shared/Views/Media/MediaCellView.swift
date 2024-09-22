//
//  mediaRowView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 08/02/2024.
//

import Foundation
import M3UKit
import SDWebImageSwiftUI
import SwiftUI
import XMLTV

struct MediaCellView: View {

	@AppStorage("FAVORITED_CHANNELS") private var favourites: [Media] = []

	@AppStorage("VIEWING_MODE") private var viewingMode: ViewingMode = .regular

	let media: Media

	var body: some View {
		HStack {
			WebImage(url: URL(string: media.attributes["tvg-logo"] ?? "")) {
				image in
				image
					.resizable()
					.aspectRatio(contentMode: .fit)
					.shadow(color: .primary, radius: 0.5)
			} placeholder: {
				Image(systemName: "photo")
			}
			.frame(width: viewingMode.photoSize, height: viewingMode.photoSize)
			.padding(.trailing, 5)

			switch viewingMode {
			case .large:
				largeViewingMode
			case .regular:
				regularViewingMode
			case .compact:
				compactViewingMode
			}
		}
		#if !os(tvOS)
			.swipeActions(edge: .leading) {
				ShareLink(item: media.url, preview: SharePreview(media.title))
				.tint(.pink)
			}
			.swipeActions(edge: .trailing) { swipeActions }
		#endif
		.contextMenu { contextMenu }
	}
}

extension MediaCellView {
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

	private var compactViewingMode: some View {
		HStack {
			HStack(spacing: 0) {
				Text(media.title)
					.fontWeight(.semibold)
					.lineLimit(1)
			}

			Spacer()

			Text(media.attributes["group-title"] ?? "Undefined")
				.font(.caption)
				.lineLimit(1)
		}
	}

	private var regularViewingMode: some View {
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
			#if !os(tvOS)
				ShareLink(item: media.url, preview: SharePreview(media.title))
			#endif
			Button(
				favourites.contains(media) ? "Un-Favourite" : "Favourite",
				systemImage: favourites.contains(media)
					? "star.slash.fill" : "star",
				role: favourites.contains(media) ? .destructive : nil
			) {
				if favourites.contains(media) {
					favourites.remove(at: favourites.firstIndex(of: media)!)
				} else {
					favourites.append(media)
				}

				Task {
					await FavouritesTip.setFavouriteEvent.donate()
				}
			}
		}
	}

	private var swipeActions: some View {
		Button(
			favourites.contains(media) ? "Un-Favourite" : "Favourite",
			systemImage: favourites.contains(media) ? "star.slash" : "star"
		) {
			if favourites.contains(media) {
				favourites.remove(at: favourites.firstIndex(of: media)!)
			} else {
				favourites.append(media)
			}

			Task {
				await FavouritesTip.setFavouriteEvent.donate()
			}
		}
		.tint(favourites.contains(media) ? .indigo : .yellow)
	}
}
