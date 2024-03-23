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

struct PlayerView: UIViewControllerRepresentable { // i have no fucking idea what im doing
	
	var media: Playlist.Media?
	var playlistName: String
	
	func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
		let urlWithoutExtension: URL = (media?.url.deletingPathExtension())!
		let dirAndURL: URL = URL(string: "\(urlWithoutExtension).m3u8")!
		
		print(media?.url.absoluteString ?? "")
		print(urlWithoutExtension)
		print(dirAndURL.absoluteString)
		
		let titleItem = AVMutableMetadataItem()
		titleItem.identifier = .commonIdentifierTitle
		titleItem.value = media?.name as (NSCopying & NSObjectProtocol)?
		
		let subTitleItem = AVMutableMetadataItem()
		subTitleItem.identifier = .iTunesMetadataTrackSubTitle
		subTitleItem.value = media?.attributes.groupTitle as (NSCopying & NSObjectProtocol)?
		
		let albumItem = AVMutableMetadataItem()
		albumItem.identifier = .iTunesMetadataAlbum
		albumItem.value = media?.attributes.groupTitle as (NSCopying & NSObjectProtocol)?
		
		let artistItem = AVMutableMetadataItem()
		artistItem.identifier = .iTunesMetadataArtist
		artistItem.value = playlistName as (NSCopying & NSObjectProtocol)?
		
		let playerItem = AVPlayerItem(url: media!.url)
		playerItem.externalMetadata = [titleItem, subTitleItem, artistItem, albumItem]
		
		let player = AVPlayer(playerItem: playerItem)
		
		playerController.allowsPictureInPicturePlayback = true
		playerController.player = player
		
		player.play()
	}
	
	func makeUIViewController(context: Context) -> AVPlayerViewController {
		return AVPlayerViewController()
	}
}
