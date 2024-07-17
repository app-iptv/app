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
import XMLTV
import SDWebImageSwiftUI

#if os(iOS) || os(tvOS)
struct PlayerViewControllerRepresentable: UIViewControllerRepresentable {
	private let name: String
	private let url: String
	private let group: String?
	private let playlistName: String
	
	internal init(name: String, url: String, group: String?, playlistName: String) {
		self.name = name
		self.url = url
		self.group = group
		self.playlistName = playlistName
	}
	
	func makeUIViewController(context: Context) -> some UIViewController {
		return PlayerViewController(name: name, url: url, group: group, playlistName: playlistName)
	}
	
	func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}
#else
struct PlayerViewControllerRepresentable: NSViewControllerRepresentable {
	private let name: String
	private let url: String
	private let group: String?
	private let playlistName: String
	
	internal init(name: String, url: String, group: String?, playlistName: String) {
		self.name = name
		self.url = url
		self.group = group
		self.playlistName = playlistName
	}
	
	func makeNSViewController(context: Context) -> some NSViewController {
		return PlayerViewController(name: name, url: url, group: group, playlistName: playlistName)
	}
	
	func updateNSViewController(_ nsViewController: NSViewControllerType, context: Context) { }
}
#endif

extension PlayerViewControllerRepresentable {
	init(media: Media, playlistName: String) {
		self.init(name: media.title, url: media.url, group: media.attributes["group-title"], playlistName: playlistName)
	}
}
