//
//  PlayerView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 04/02/2024.
//

import Foundation
import AVKit
import SwiftUI
import M3UKit
import XMLTV
import SDWebImageSwiftUI

struct PlayerViewControllerRepresentable: UIViewControllerRepresentable {
	private let name: String
	private let url: String
	private let group: String?
	private let playlistName: String
	
	@Binding private var currentProgram: TVProgram?
	
	internal init(name: String, url: String, group: String?, playlistName: String, currentProgram: Binding<TVProgram?>) {
		self.name = name
		self.url = url
		self.group = group
		self.playlistName = playlistName
		self._currentProgram = currentProgram
	}
	
	func makeUIViewController(context: Context) -> AVPlayerViewController {
		let url = URL(string: url)!
		
		let playerItem = AVPlayerItem(url: url)
		let player = AVPlayer(playerItem: playerItem)
		let playerController = AVPlayerViewController()
		
		playerController.allowsPictureInPicturePlayback 					= true
		
		#if os(tvOS)
		playerController.playbackControlsIncludeTransportBar 				= true
		playerController.transportBarIncludesTitleView 						= true
		playerController.playbackControlsIncludeInfoViews 					= true
		#else
		playerController.entersFullScreenWhenPlaybackBegins 				= true
		playerController.canStartPictureInPictureAutomaticallyFromInline 	= true
		playerController.exitsFullScreenWhenPlaybackEnds 					= true
		#endif
		
		player.usesExternalPlaybackWhileExternalScreenIsActive 				= true
		player.allowsExternalPlayback										= true
		
		let group = group ?? String(localized: "Untitled")
		
		let titleItem = createMetadataItem(for: .commonIdentifierTitle, value: name)
		
		let subTitleItem = createMetadataItem(for: .iTunesMetadataTrackSubTitle, value: group)
		
		let albumItem = createMetadataItem(for: .commonIdentifierAlbumName, value: group)
		
		let artistItem = createMetadataItem(for: .commonIdentifierArtist, value: playlistName)
		
		playerItem.externalMetadata = [titleItem, subTitleItem, artistItem, albumItem]
		
		playerController.player = player
		player.play()
		return playerController
	}
	
	func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
		#if os(tvOS)
		if let currentProgram {
			let hostingController = UIHostingController(rootView: InfoView(program: currentProgram))
			hostingController.title = String(localized: "Info")
			
			playerController.customInfoViewControllers = [
				hostingController
			]
		}
		#endif
	}
	
	private func createMetadataItem(for identifier: AVMetadataIdentifier,
									value: Any) -> AVMetadataItem {
		let item = AVMutableMetadataItem()
		item.identifier = identifier
		item.value = value as? NSCopying & NSObjectProtocol
		// Specify "und" to indicate an undefined language.
		item.extendedLanguageTag = "und"
		return item.copy() as! AVMetadataItem
	}
	
	struct InfoView: View {
		
		var program: TVProgram
		
		var body: some View {
			VStack {
				// Container for dark grey part
				HStack(alignment: .top, spacing: 10) {
					// Image
					WebImage(url: URL(string: program.icon ?? "")) { image in
						image
							.resizable()
							.aspectRatio(contentMode: .fit)
					} placeholder: {
						Image(systemName: "photo.tv")
							.imageScale(.large)
					}
					.frame(maxWidth: 300, maxHeight: 150) // Adjust size as needed
					.clipShape(.rect(cornerRadius: 10))
					
					// Text and buttons
					VStack(alignment: .leading, spacing: 10) {
						// Title Text
						Text(program.title ?? "Untitled")
							.font(.headline)
						
						// Description Text
						Text(program.description ?? "No description.")
							.lineSpacing(5)
							.lineLimit(3)
					}
					
					Spacer()
				}
				.padding(.top)
				.background(Color(.darkGray))
				.cornerRadius(10)
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
		}
	}
}

extension PlayerViewControllerRepresentable {
	init(media: Media, playlistName: String, currentProgram: Binding<TVProgram?>) {
		self.init(name: media.title, url: media.url, group: media.attributes["group-title"], playlistName: playlistName, currentProgram: currentProgram)
	}
}
