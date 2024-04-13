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

struct PlayerView: UIViewControllerRepresentable {
	
	let media: Media
	let playlistName: String
	
	func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
		let url = URL(string: media.url)!
		
		let urlWithoutExtension: URL = (url.deletingPathExtension())
		let dirAndURL: URL = URL(string: "\(urlWithoutExtension).m3u8")!
		
		print(media.url)
		print(urlWithoutExtension)
		print(dirAndURL.absoluteString)
		
		// Initialize the AVPlayer with the video URL
		let playerItem = AVPlayerItem(url: url)
		let player = AVPlayer(playerItem: playerItem)
		
		playerController.allowsPictureInPicturePlayback = true
		player.allowsExternalPlayback = true
		playerController.player = player
		
		let titleItem = AVMutableMetadataItem()
		titleItem.identifier = .commonIdentifierTitle
		titleItem.value = media.title as (NSCopying & NSObjectProtocol)?
		
		let subTitleItem = AVMutableMetadataItem()
		subTitleItem.identifier = .iTunesMetadataTrackSubTitle
		subTitleItem.value = media.attributes["group-title"] as (NSCopying & NSObjectProtocol)?
		
		let albumItem = AVMutableMetadataItem()
		albumItem.identifier = .commonIdentifierAlbumName
		albumItem.value = media.attributes["group-title"] as (NSCopying & NSObjectProtocol)?
		
		let artistItem = AVMutableMetadataItem()
		artistItem.identifier = .commonIdentifierArtist
		artistItem.value = playlistName as (NSCopying & NSObjectProtocol)?
		
		playerItem.externalMetadata = [titleItem, subTitleItem, artistItem, albumItem]
		
		player.play()
	}
	
	func makeUIViewController(context: Context) -> AVPlayerViewController {
		return AVPlayerViewController()
	}
}

struct SinglePlayerView: UIViewControllerRepresentable {
	
	let name: String
	let url: String
	let group: String?
	let playlistName: String
	
	func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
		let url = URL(string: url)!
		
		let urlWithoutExtension: URL = (url.deletingPathExtension())
		let dirAndURL: URL = URL(string: "\(urlWithoutExtension).m3u8")!
		
		print(url)
		print(urlWithoutExtension)
		print(dirAndURL.absoluteString)
		
		// Initialize the AVPlayer with the video URL
		let playerItem = AVPlayerItem(url: url)
		let player = AVPlayer(playerItem: playerItem)
		
		playerController.allowsPictureInPicturePlayback = true
		player.allowsExternalPlayback = true
		playerController.player = player
		
		let titleItem = AVMutableMetadataItem()
		titleItem.identifier = .commonIdentifierTitle
		titleItem.value = name as (NSCopying & NSObjectProtocol)?
		
		let subTitleItem = AVMutableMetadataItem()
		subTitleItem.identifier = .iTunesMetadataTrackSubTitle
		subTitleItem.value = group as (NSCopying & NSObjectProtocol)?
		
		let albumItem = AVMutableMetadataItem()
		albumItem.identifier = .commonIdentifierAlbumName
		albumItem.value = group as (NSCopying & NSObjectProtocol)?
		
		let artistItem = AVMutableMetadataItem()
		artistItem.identifier = .commonIdentifierArtist
		artistItem.value = playlistName as (NSCopying & NSObjectProtocol)?
		
		playerItem.externalMetadata = [titleItem, subTitleItem, artistItem, albumItem]
		
		player.play()
	}
	
	func makeUIViewController(context: Context) -> AVPlayerViewController {
		return AVPlayerViewController()
	}
}

