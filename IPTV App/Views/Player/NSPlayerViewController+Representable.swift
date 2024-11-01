//
//  PlayerViewController.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 10/07/2024.
//

import AppKit
import AVKit
import M3UKit
import SwiftUI

class PlayerViewController: NSViewController {
	private var name: String
	private var url: String
	private var group: String?
	private var playlistName: String
	
	init(name: String, url: String, group: String?, playlistName: String) {
		self.name = name
		self.url = url
		self.group = group
		self.playlistName = playlistName
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		self.name = ""
		self.url = ""
		self.group = nil
		self.playlistName = ""
		
		fatalError("init(coder:) has not been implemented")
	}
	
	var player: AVPlayer? = nil
	
	override func viewDidDisappear() {
		super.viewDidDisappear()
		
		player?.pause()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		guard let url = URL(string: url) else { return }
		
		let playerItem = AVPlayerItem(url: url)
		let playerView = AVPlayerView()
		let player = AVPlayer(playerItem: playerItem)
		
		playerView.allowsPictureInPicturePlayback = true
		playerView.showsFullScreenToggleButton = true
		player.allowsExternalPlayback = true
		
		self.player = player
		playerView.player = self.player
		self.player?.play()
		
		self.view = playerView
	}
	
	private func createMetadataItem(
		for identifier: AVMetadataIdentifier,
		value: Any
	) -> AVMetadataItem {
		let item = AVMutableMetadataItem()
		item.identifier = identifier
		item.value = value as? NSCopying & NSObjectProtocol
		// Specify "und" to indicate an undefined language.
		item.extendedLanguageTag = "und"
		return item.copy() as! AVMetadataItem
	}
}

struct PlayerViewControllerRepresentable: NSViewControllerRepresentable {
	private let name: String
	private let url: String
	private let group: String?
	private let playlistName: String
	
	internal init(
		name: String, url: String, group: String?, playlistName: String
	) {
		self.name = name
		self.url = url
		self.group = group
		self.playlistName = playlistName
	}
	
	func makeNSViewController(context: Context) -> some NSViewController {
		return PlayerViewController(
			name: name, url: url, group: group, playlistName: playlistName)
	}
	
	func updateNSViewController(
		_ nsViewController: NSViewControllerType, context: Context
	) {}
}
