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
	
	@State var mediaURL: String = ""
	@Binding var openedSingleStream: Bool
	
	@State var isPresented: Bool = false
	
    var body: some View {
		VStack {
			Text("Open Single Media")
				.font(.largeTitle)
				.bold()
				.padding()
			
			TextField("Enter URL", text: $mediaURL)
				.textFieldStyle(.roundedBorder)
				.textInputAutocapitalization(.never)
			
			HStack(spacing: 20) {
				Button("Open", systemImage: "play.fill") { isPresented.toggle() }
					.disabled(mediaURL.isEmpty)
					.buttonStyle(.borderedProminent)
				Button("Cancel") { openedSingleStream.toggle() }
					.buttonStyle(.bordered)
			}
			.padding()
		}
		.navigationTitle("Open Single Media")
		.sheet(isPresented: $isPresented) { playerView }
		.padding()
    }
	
	var playerView: some View {
		PlayerView(
			media: Playlist.Media(
				duration: 0,
				attributes: Playlist.Media.Attributes(groupTitle: "Single Stream"),
				kind: .unknown,
				name: "Single Stream",
				url: URL(string: mediaURL)!
			),
			playlistName: "Single Stream"
		)
		.aspectRatio(16/9, contentMode: .fit)
		.cornerRadius(10)
		#if os(macOS)
		.frame(width: 800, height: 500)
		#endif
		.padding()
	}
}
