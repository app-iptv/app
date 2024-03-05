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
	
	var media: Playlist.Media?
	var playlistName: String
	
	func updateNSView(_ nsView: AVPlayerView, context: Context) {
		let urlWithoutExtension: URL = (media?.url.deletingPathExtension()) ?? URL(string: "https://www.google.com/?client=safari")!
		let dirAndURL: URL = URL(string: "\(urlWithoutExtension).m3u8")!
		
		#if DEBUG
		print(media?.url.absoluteString ?? "")
		print(urlWithoutExtension)
		print(dirAndURL.absoluteString)
		#endif
		
		// Initialize the AVPlayer with the video URL
		let playerItem = AVPlayerItem(url: dirAndURL)
		let player = AVPlayer(playerItem: playerItem)
		// Create the AVPlayerView
		let playerView = AVPlayerView()
		
		let titleItem = AVMutableMetadataItem()
		titleItem.identifier = .commonIdentifierTitle
		titleItem.value = (media?.name) as (NSCopying & NSObjectProtocol)?
		
		let subTitleItem = AVMutableMetadataItem()
		subTitleItem.identifier = .iTunesMetadataTrackSubTitle
		subTitleItem.value = (media?.attributes.groupTitle) as (NSCopying & NSObjectProtocol)?
		
		let albumItem = AVMutableMetadataItem()
		albumItem.identifier = .commonIdentifierAlbumName
		albumItem.value = (media?.attributes.groupTitle) as (NSCopying & NSObjectProtocol)?
		
		let artistItem = AVMutableMetadataItem()
		artistItem.identifier = .commonIdentifierArtist
		artistItem.value = (playlistName) as (NSCopying & NSObjectProtocol)?
		
		// playerItem.externalMetadata = [titleItem, subTitleItem, albumItem, artistItem]
		
		playerView.player = player
		playerView.showsFullScreenToggleButton = true
		playerView.allowsPictureInPicturePlayback = true
		
		playerView.controlsStyle = .floating
		
		player.play()
	}
	
	func makeNSView(context: Context) -> AVPlayerView {
		return AVPlayerView()
	}
	
}
#else
struct PlayerView: UIViewControllerRepresentable { // i have no fucking idea what im doing
	
	var media: Playlist.Media?
	var playlistName: String
	
	func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
		let urlWithoutExtension: URL = (media?.url.deletingPathExtension())!
		let dirAndURL: URL = URL(string: "\(urlWithoutExtension).m3u8")!
		
		print(media?.url.absoluteString ?? "")
		print(urlWithoutExtension)
		print(dirAndURL.absoluteString)
		
		// Initialize the AVPlayer with the video URL
		let playerItem = AVPlayerItem(url: dirAndURL)
		let player = AVPlayer(playerItem: playerItem)
		// Create the AVPlayerView
		playerController.player = player
		
		let titleItem = AVMutableMetadataItem()
		titleItem.identifier = .commonIdentifierTitle
		titleItem.value = (media?.name) as (NSCopying & NSObjectProtocol)?
		
		let subTitleItem = AVMutableMetadataItem()
		subTitleItem.identifier = .iTunesMetadataTrackSubTitle
		subTitleItem.value = (media?.attributes.groupTitle) as (NSCopying & NSObjectProtocol)?
		
		let albumItem = AVMutableMetadataItem()
		albumItem.identifier = .commonIdentifierAlbumName
		albumItem.value = (media?.attributes.groupTitle) as (NSCopying & NSObjectProtocol)?
		
		let artistItem = AVMutableMetadataItem()
		artistItem.identifier = .commonIdentifierArtist
		artistItem.value = (playlistName) as (NSCopying & NSObjectProtocol)?
		
		playerItem.externalMetadata = [titleItem, subTitleItem, artistItem, albumItem]
		
		player.play()
	}
	
	func makeUIViewController(context: Context) -> AVPlayerViewController {
		return AVPlayerViewController()
	}
}
#endif
