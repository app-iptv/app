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
		let urlWithoutExtension: URL = (media.url.deletingPathExtension())
		let dirAndURL: URL = URL(string: "\(urlWithoutExtension).m3u8")!
		
		print(media.url.absoluteString)
		print(urlWithoutExtension)
		print(dirAndURL.absoluteString)
		
		// Initialize the AVPlayer with the video URL
		let playerItem = AVPlayerItem(url: media.url)
		let player = AVPlayer(playerItem: playerItem)
		
		playerController.allowsPictureInPicturePlayback = true
		player.allowsExternalPlayback = true
		playerController.player = player
		
		let titleItem = AVMutableMetadataItem()
		titleItem.identifier = .commonIdentifierTitle
		titleItem.value = media.name as (NSCopying & NSObjectProtocol)?
		
		let subTitleItem = AVMutableMetadataItem()
		subTitleItem.identifier = .iTunesMetadataTrackSubTitle
		subTitleItem.value = media.attributes.groupTitle as (NSCopying & NSObjectProtocol)?
		
		let albumItem = AVMutableMetadataItem()
		albumItem.identifier = .commonIdentifierAlbumName
		albumItem.value = media.attributes.groupTitle as (NSCopying & NSObjectProtocol)?
		
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
