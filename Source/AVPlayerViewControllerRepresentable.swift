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
	var media: Playlist.Media
	
	func updateNSView(_ nsView: AVPlayerView, context: Context) {
		// Here you can update the player view if needed, based on your app's state
	}
	func makeNSView(context: Context) -> AVPlayerView {
		// Initialize the AVPlayer with the video URL
		let playerItem = AVPlayerItem(url: media.url)
		let player = AVPlayer(playerItem: playerItem)
		// Create the AVPlayerView
		let playerView = AVPlayerView()
		playerView.player = player
		playerView.showsFullScreenToggleButton = true
		playerView.allowsPictureInPicturePlayback = true
		playerView.player?.allowsExternalPlayback = true
		return playerView
	}
}
#else
struct PlayerView: UIViewControllerRepresentable { // i have no fucking idea what im doing
	
	var media: Playlist.Media
	
	func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
		let playerItem = AVPlayerItem(url: media.url)
		let player = AVPlayer(playerItem: playerItem)
		playerController.player = player
		playerController.allowsPictureInPicturePlayback = true
		playerController.entersFullScreenWhenPlaybackBegins = true
		playerController.player?.play()
	}
	
	func makeUIViewController(context: Context) -> AVPlayerViewController {
		return AVPlayerViewController()
	}
}
#endif
