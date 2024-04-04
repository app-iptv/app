//
//  MediaItemView.swift
//  IPTV TV
//
//  Created by Pedro Cordeiro on 14/03/2024.
//

import SwiftUI
import SDWebImageSwiftUI
import M3UKit

struct MediaItemView: View {
	let media: Media
	
	var body: some View {
		NavigationLink(value: media) {
			VStack {
				Spacer()
				WebImage(url: URL(string: media.attributes.logo ?? "")) { image in
					image
						.resizable()
						.scaledToFit()
				} placeholder: {
					Image(systemName: "photo")
				}
				
				Spacer()
				
				Divider()
					.padding(.vertical)
				
				HStack(spacing: 10) {
					Text(media.name)
						.font(.footnote)
					Divider()
						.frame(height: 20)
					Text(media.attributes.groupTitle ?? "")
						.font(.footnote)
				}
				.padding(.bottom)
			}
			.frame(width: 400, height: 400)
		}
	}
}
