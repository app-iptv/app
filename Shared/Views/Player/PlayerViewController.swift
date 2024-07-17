//
//  PlayerViewController.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 10/07/2024.
//

#if canImport(AppKit)
import AppKit
#else
import UIKit
#endif
import AVKit
import M3UKit

#if os(macOS)
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
		let playerController = AVPlayerView()
		let player = AVPlayer(playerItem: playerItem)
		
		playerController.allowsPictureInPicturePlayback = true
		player.allowsExternalPlayback = true
		
		self.player = player
		playerController.player = self.player
		self.player?.play()
		
		self.view.addSubview(playerController)
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
}
#else
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
		
		player?.pause()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		guard let url = URL(string: url) else { return }
		
		let playerItem = AVPlayerItem(url: url)
		let playerController = AVPlayerViewController()
		let player = AVPlayer(playerItem: playerItem)
		
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
		
		self.player = player
		playerController.player = self.player
		self.player?.play()
		
		// First, add the view of the child to the view of the parent
		self.view.addSubview(playerController.view)

		// Then, add the child to the parent
		self.addChild(playerController)

		// Finally, notify the child that it was moved to a parent
		playerController.didMove(toParent: self)
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
}
#endif

extension PlayerViewController {
	convenience init(media: Media, playlistName: String) {
		self.init(name: media.title, url: media.url, group: media.attributes["group-title"], playlistName: playlistName)
	}
}
