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
	private var size: PosterSize
	
	internal init(media: Media, isTV: Bool, size: PosterSize) {
		self.media = media
		self.isTV = isTV
		self.size = size
	}
	
	#if os(tvOS)
	@State private var currentProgram: TVProgram? = nil
	#endif
	
	var body: some View {
		PosterView(title: media.title, size: size) {
			isWatching.toggle()
			
			guard !isTV else { return }
			
			recents.removeAll { $0 == media }
			recents.insert(media, at: 0)
			
			guard !(recents.count > 3) else { return }
			
			recents.removeLast()
		} image: {
			WebImage(url: URL(string: media.attributes["tvg-logo"] ?? "")) { image in
				image
					.resizable()
					.scaledToFit()
					.shadow(color: .black, radius: 0.25)
					.clipShape(.rect(cornerRadius: 10))
			} placeholder: {
				Image(systemName: "photo.tv")
			}
		}
		#if os(tvOS)
		.task {
			let channels = EPGFetchingModel.shared.xmlTV?.getChannels()
			let channel = channels?.first { channel in
				channel.id == media.attributes["tvg-id"]
			}
			
			guard let channel else { return }
			
			let programs = EPGFetchingModel.shared.xmlTV?.getPrograms(channel: channel)
			let filtered = programs?.filter(EPGFetchingModel.shared.isNowBetweenDates)
			
			currentProgram = filtered?.first
		}
		#endif
		.fullScreenCover(isPresented: $isWatching) {
			PlayerViewControllerRepresentable(media: media, playlistName: "Movies & TV Shows", currentProgram: $currentProgram)
				.id(currentProgram)
				.ignoresSafeArea()
		}
		.id(currentProgram)
	}
}
