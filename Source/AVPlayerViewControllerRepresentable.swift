//
//  AVPlayerViewControllerRepresentable.swift
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
struct PlayerView: NSViewRepresentable {
	
	var playlistName: String
	var media: Playlist.Media
	
	func updateNSView(_ nsView: AVPlayerView, context: Context) {
		// Here you can update the player view if needed, based on your app's state
	}
	
	func makeNSView(context: Context) -> AVPlayerView {
		
		let urlWithoutExtension: URL = media.url.deletingPathExtension()
		let dirAndURL: URL = URL(string: "\(urlWithoutExtension).m3u8")!
		
		print(media.url.absoluteString)
		print(urlWithoutExtension)
		print(dirAndURL.absoluteString)
		
		// Initialize the AVPlayer with the video URL
		let playerItem = AVPlayerItem(url: dirAndURL)
		let player = AVPlayer(playerItem: playerItem)
		// Create the AVPlayerView
		let playerView = AVPlayerView()
		
		let playerItemTitleMetadata = AVMutableMetadataItem()
		playerItemTitleMetadata.identifier = .commonIdentifierTitle
		playerItemTitleMetadata.value = media.name as (NSCopying & NSObjectProtocol)?
		
		let playerItemSubtitleMetadata = AVMutableMetadataItem()
		playerItemSubtitleMetadata.identifier = .commonIdentifierAlbumName
		playerItemSubtitleMetadata.value = playlistName as (NSCopying & NSObjectProtocol)?
		
		playerView.player = player
		playerView.showsFullScreenToggleButton = true
		playerView.allowsPictureInPicturePlayback = true
		
		playerView.controlsStyle = .inline
		
		return playerView
	}
	
}
#else
struct PlayerView: UIViewControllerRepresentable { // i have no fucking idea what im doing
	
	var playlistName: String
	var media: Playlist.Media
	
	func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
		let playerItem = AVPlayerItem(url: media.url)
		let player = AVPlayer(playerItem: playerItem)
		playerController.player = player
		
		let playerItemTitleMetadata = AVMutableMetadataItem()
		playerItemTitleMetadata.identifier = .commonIdentifierTitle
		playerItemTitleMetadata.value = media.name as (NSCopying & NSObjectProtocol)?
		
		let playerItemSubtitleMetadata = AVMutableMetadataItem()
		playerItemSubtitleMetadata.identifier = .iTunesMetadataTrackSubTitle
		playerItemSubtitleMetadata.value = playlistName as (NSCopying & NSObjectProtocol)?
		
		playerItem.externalMetadata = [playerItemTitleMetadata, playerItemSubtitleMetadata]
		
		playerController.player?.play()
	}
	
	func makeUIViewController(context: Context) -> AVPlayerViewController {
		return AVPlayerViewController()
	}
}
#endif
