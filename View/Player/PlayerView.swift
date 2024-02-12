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

// MARK: AVPlayerViewControllerRepresentable
#if os(macOS)
struct PlayerView: NSViewRepresentable { // i have no fucking idea what im doing
	
	@Binding var media: Playlist.Media?
	
	func updateNSView(_ nsView: AVPlayerView, context: Context) {
		let urlWithoutExtension: URL = (media?.url.deletingPathExtension()) ?? URL(string: "https://www.google.com/?client=safari")!
		let dirAndURL: URL = URL(string: "\(urlWithoutExtension).m3u8")!
		
		print(media?.url.absoluteString ?? "")
		print(urlWithoutExtension)
		print(dirAndURL.absoluteString)
		
		// Initialize the AVPlayer with the video URL
		let playerItem = AVPlayerItem(url: dirAndURL)
		let player = AVPlayer(playerItem: playerItem)
		// Create the AVPlayerView
		let playerView = AVPlayerView()
		
		let playerItemTitleMetadata = AVMutableMetadataItem()
		playerItemTitleMetadata.identifier = .commonIdentifierTitle
		playerItemTitleMetadata.value = (media?.name) as (NSCopying & NSObjectProtocol)?
		
		let playerItemSubtitleMetadata = AVMutableMetadataItem()
		playerItemSubtitleMetadata.identifier = .commonIdentifierAlbumName
		playerItemSubtitleMetadata.value = (media?.attributes.groupTitle) as (NSCopying & NSObjectProtocol)?
		
		playerView.player = player
		playerView.showsFullScreenToggleButton = true
		playerView.allowsPictureInPicturePlayback = true
		
		playerView.controlsStyle = .floating
	}
	
	func makeNSView(context: Context) -> AVPlayerView {
		return AVPlayerView()
	}
	
}
#else
struct PlayerView: UIViewControllerRepresentable { // i have no fucking idea what im doing
	
	@Binding var media: Playlist.Media?
	
	func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
		let urlWithoutExtension: URL = (media?.url.deletingPathExtension()) ?? URL(string: "https://www.google.com/?client=safari")!
		let dirAndURL: URL = URL(string: "\(urlWithoutExtension).m3u8")!
		
		print(media?.url.absoluteString ?? "")
		print(urlWithoutExtension)
		print(dirAndURL.absoluteString)
		
		// Initialize the AVPlayer with the video URL
		let playerItem = AVPlayerItem(url: dirAndURL)
		let player = AVPlayer(playerItem: playerItem)
		// Create the AVPlayerView
		playerController.player = player
		
		let playerItemTitleMetadata = AVMutableMetadataItem()
		playerItemTitleMetadata.identifier = .commonIdentifierTitle
		playerItemTitleMetadata.value = (media?.name) as (NSCopying & NSObjectProtocol)?
		
		let playerItemSubtitleMetadata = AVMutableMetadataItem()
		playerItemSubtitleMetadata.identifier = .iTunesMetadataTrackSubTitle
		playerItemSubtitleMetadata.value = (media?.attributes.groupTitle) as (NSCopying & NSObjectProtocol)?
		
		playerItem.externalMetadata = [playerItemTitleMetadata, playerItemSubtitleMetadata]
		
		playerController.player?.play()
	}
	
	func makeUIViewController(context: Context) -> AVPlayerViewController {
		return AVPlayerViewController()
	}
}
#endif
