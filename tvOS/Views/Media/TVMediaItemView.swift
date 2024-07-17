//
//  TVMediaItemView.swift
//  IPTV TV App
//
//  Created by Pedro Cordeiro on 19/05/2024.
//

import SwiftUI
import XMLTV
import SDWebImageSwiftUI

struct TVMediaItemView: View {
	@State private var isWatching: Bool = false
	
	@AppStorage("RECENTLY_WATCHED_CHANNELS") private var recents: [Media] = []
	
	private var media: Media
	private var isTV: Bool
	
	internal init(media: Media, isTV: Bool) {
		self.media = media
		self.isTV = isTV
	}
	
	#if os(tvOS)
	@State private var currentProgram: TVProgram? = nil
	#endif
	
	var body: some View {
		Button {
			isWatching.toggle()
			
			guard !isTV else { return }
			
			recents.removeAll { $0 == media }
			recents.insert(media, at: 0)
			
			guard !(recents.count > 3) else { return }
			
			recents.removeLast()
		} label: {
			WebImage(url: URL(string: media.attributes["tvg-logo"] ?? "")) { image in
				image
					.resizable()
					.scaledToFit()
					.frame(width: 300, height: 200)
			} placeholder: {
				Image(systemName: "questionmark.app.fill")
					.resizable()
					.scaledToFit()
					.padding(50)
					.frame(width: 300, height: 200)
			}
			.containerRelativeFrame(.horizontal, count: 5, spacing: 40)
			
			Text(media.title)
				.font(.caption)
				.frame(maxWidth: 300)
		}
		.buttonStyle(.borderless)
		.task {
			guard
				let channels = EPGFetchingModel.shared.xmlTV?.getChannels(),
				let channel = channels.first(where: { $0.id == media.attributes["tvg-id"] })
			else { return }
			
			let programs = EPGFetchingModel.shared.xmlTV?.getPrograms(channel: channel)
			let filtered = programs?.filter(EPGFetchingModel.shared.isNowBetweenDates)
			
			currentProgram = filtered?.first
		}
		.fullScreenCover(isPresented: $isWatching) {
			PlayerViewControllerRepresentable(media: media, playlistName: "Movies & TV Shows", currentProgram: $currentProgram)
				.id(currentProgram)
				.ignoresSafeArea()
		}
	}
}
