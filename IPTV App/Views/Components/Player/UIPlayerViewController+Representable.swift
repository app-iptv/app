//
//  PlayerViewController.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 10/07/2024.
//

import AVKit
import M3UKit
import SwiftUI

class PlayerViewController: UIViewController {
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

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)

		self.player?.pause()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		
		guard let url = URL(string: url) else { return }
		
		let playerItem = AVPlayerItem(url: url)
		let playerController = AVPlayerViewController()
		let player = AVPlayer(playerItem: playerItem)
		
		playerController.allowsPictureInPicturePlayback = true
		playerController.entersFullScreenWhenPlaybackBegins = true
		playerController.canStartPictureInPictureAutomaticallyFromInline = true
		playerController.exitsFullScreenWhenPlaybackEnds = true
		
		player.usesExternalPlaybackWhileExternalScreenIsActive = true
		player.allowsExternalPlayback = true
		
		let group = group ?? String(localized: "Untitled")
		
		let titleItem = createMetadataItem(
			for: .commonIdentifierTitle, value: name)
		
		let subTitleItem = createMetadataItem(
			for: .iTunesMetadataTrackSubTitle, value: group)
		
		let albumItem = createMetadataItem(
			for: .commonIdentifierAlbumName, value: group)
		
		let artistItem = createMetadataItem(
			for: .commonIdentifierArtist, value: playlistName)
		
		playerItem.externalMetadata = [titleItem, subTitleItem, artistItem, albumItem]
		
		self.player = player
		playerController.player = self.player
		
		// First, add the view of the child to the view of the parent
		self.view.addSubview(playerController.view)
		
		// Then, add the child to the parent
		self.addChild(playerController)
		
		// Finally, notify the child that it was moved to a parent
		playerController.didMove(toParent: self)
		
		self.player?.play()
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

struct PlayerViewControllerRepresentable: UIViewControllerRepresentable {
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

	func makeUIViewController(context: Context) -> some UIViewController {
		return PlayerViewController(name: name, url: url, group: group, playlistName: playlistName)
	}

	func updateUIViewController(
		_ uiViewController: UIViewControllerType, context: Context
	) {}
}
