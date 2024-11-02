//
//  MediaGridItemView.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 24/08/2024.
//

import SDWebImageSwiftUI
import SwiftUI

struct MediaGridItemView: View {
	let media: Media
	let index: Int

	var body: some View {
		GroupBox {
			VStack(spacing: 5) {
				WebImage(url: URL(string: media.attributes["tvg-logo"] ?? "")) {
					image in
					image
						.resizable()
						.scaledToFit()
						.shadow(color: .primary, radius: 0.5)
				} placeholder: {
					Image(systemName: "photo.tv")
						.imageScale(.large)
				}

				Divider()

				HStack {
					Text(media.title)

					if let groupTitle = media.attributes["group-title"] {
						Spacer()

						Text(groupTitle)
							.font(.caption)
					}

					Spacer()

					Text(String(index))
				}
			}
		}
	}
}
