//
//  SingleStreamView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 16/02/2024.
//

import SwiftUI
import M3UKit
import AVKit

struct SingleStreamView: View {
	
	@State var mediaGroup: String = "Single Stream"
	@State var mediaName: String = "Single Stream"
	@State var mediaURL: String = ""
	
	@State var playlistName: String = "Single Stream"
	
	@State var isPresented: Bool = false
	
    var body: some View {
		VStack {
			Text("Open Single Stream")
				.font(.largeTitle)
				.bold()
				.padding()
			
			TextField("Enter URL", text: $mediaURL)
				.textFieldStyle(.roundedBorder)
				.textInputAutocapitalization(.never)
			#if os(macOS)
				.frame(width: 300)
			#endif
			
			Button {
				isPresented.toggle()
			} label: {
				Label("Open", systemImage: "play.fill")
			}
			.buttonStyle(.borderedProminent)
			.padding()
		}
		.navigationTitle("Open Single Media")
		.sheet(isPresented: $isPresented) {
			SinglePlayerView(mediaGroup: $mediaGroup, mediaName: $mediaName, mediaURL: $mediaURL, playlistName: $playlistName)
				.aspectRatio(16/9, contentMode: .fit)
				.cornerRadius(10)
				.padding()
		}
		.padding()
    }
}

#if os(macOS)
struct SinglePlayerView: NSViewRepresentable { // i have no fucking idea what im doing
	
	@Binding var mediaGroup: String
	@Binding var mediaName: String
	@Binding var mediaURL: String
	
	@Binding var playlistName: String
	
	func updateNSView(_ nsView: AVPlayerView, context: Context) {
		let urlWithoutExtension: URL = (URL(string: mediaURL)?.deletingPathExtension()) ?? URL(string: "https://www.google.com")!
		let dirAndURL: URL = URL(string: "\(urlWithoutExtension).m3u8")!
		
		#if DEBUG
		print(mediaURL)
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
		titleItem.value = (mediaName) as (NSCopying & NSObjectProtocol)?
		
		let subTitleItem = AVMutableMetadataItem()
		subTitleItem.identifier = .iTunesMetadataTrackSubTitle
		subTitleItem.value = (mediaGroup) as (NSCopying & NSObjectProtocol)?
		
		let albumItem = AVMutableMetadataItem()
		albumItem.identifier = .commonIdentifierAlbumName
		albumItem.value = (mediaGroup) as (NSCopying & NSObjectProtocol)?
		
		let artistItem = AVMutableMetadataItem()
		artistItem.identifier = .commonIdentifierArtist
		artistItem.value = (playlistName) as (NSCopying & NSObjectProtocol)?
		
		// playerItem.externalMetadata = [titleItem, albumItem, artistItem]
		
		playerView.player = player
		playerView.showsFullScreenToggleButton = true
		playerView.allowsPictureInPicturePlayback = true
		
		playerView.controlsStyle = .floating
	}
	
	func makeNSView(context: Context) -> AVPlayerView {
		return AVPlayerView()
	}
	
}
#else
struct SinglePlayerView: UIViewControllerRepresentable { // i have no fucking idea what im doing
	
	@Binding var mediaGroup: String
	@Binding var mediaName: String
	@Binding var mediaURL: String
	
	@Binding var playlistName: String
	
	func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
		let urlWithoutExtension: URL = (URL(string: mediaURL)?.deletingPathExtension()) ?? URL(string: "https://www.google.com")!
		let dirAndURL: URL = URL(string: "\(urlWithoutExtension).m3u8")!
		
		#if DEBUG
		print(mediaURL)
		print(urlWithoutExtension)
		print(dirAndURL.absoluteString)
		#endif
		
		// Initialize the AVPlayer with the video URL
		let playerItem = AVPlayerItem(url: dirAndURL)
		let player = AVPlayer(playerItem: playerItem)
		// Create the AVPlayerView
		playerController.player = player
		
		let titleItem = AVMutableMetadataItem()
		titleItem.identifier = .commonIdentifierTitle
		titleItem.value = (mediaName) as (NSCopying & NSObjectProtocol)?
		
		let subTitleItem = AVMutableMetadataItem()
		subTitleItem.identifier = .iTunesMetadataTrackSubTitle
		subTitleItem.value = (mediaGroup) as (NSCopying & NSObjectProtocol)?
		
		let albumItem = AVMutableMetadataItem()
		albumItem.identifier = .commonIdentifierAlbumName
		albumItem.value = (mediaGroup) as (NSCopying & NSObjectProtocol)?
		
		let artistItem = AVMutableMetadataItem()
		artistItem.identifier = .commonIdentifierArtist
		artistItem.value = (playlistName) as (NSCopying & NSObjectProtocol)?
		
		playerItem.externalMetadata = [titleItem, artistItem, albumItem]
	}
	
	func makeUIViewController(context: Context) -> AVPlayerViewController {
		return AVPlayerViewController()
	}
}
#endif
