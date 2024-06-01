//
//  MediaItemView.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 28/04/2024.
//

import SwiftUI
import XMLTV

struct MediaItemView: View {
	@AppStorage("FAVORITED_CHANNELS") private var favourites: [Media] = []
	
	private let media: Media
	private let playlistName: String
	
	#if !os(tvOS)
	private let epgLink: String
	private let medias: [Media]
	
	@State private var programs: [TVProgram]? = nil
	
	internal init(media: Media, playlistName: String, epgLink: String, medias: [Media], programs: [TVProgram]? = nil) {
		self.media = media
		self.playlistName = playlistName
		self.epgLink = epgLink
		self.medias = medias
		self.programs = programs
		self.isViewing = isViewing
	}
	#else
	@State var currentProgram: TVProgram? = nil
	
	internal init(media: Media, playlistName: String) {
		self.media = media
		self.playlistName = playlistName
	}
	#endif
	
	@State private var isViewing: Bool = false
	
	var body: some View {
		#if os(tvOS)
		Button {
			isViewing.toggle()
		} label: {
			MediaCellView(media: media)
		}
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
		.fullScreenCover(isPresented: $isViewing) {
			PlayerViewControllerRepresentable(media: media, playlistName: playlistName, currentProgram: $currentProgram)
				.ignoresSafeArea()
		}
		#else
		NavigationLink {
			MediaDetailView(playlistName: playlistName, media: media, epgLink: epgLink)
		} label: {
			MediaCellView(media: media)
		}
		.badge(medias.firstIndex(of: media)!+1)
		#endif
	}
}
