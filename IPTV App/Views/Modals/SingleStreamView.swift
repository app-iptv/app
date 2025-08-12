//
//  SingleStreamView.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 16/02/2024.
//

import AVKit
import M3UKit
import SwiftUI

struct SingleStreamView: View {
	@Environment(AppState.self) var appState
	
	@State var mediaURL: String = ""

	@State var isPresented: Bool = false

	var body: some View {
		VStack {
			Text("Open Single Media")
				.font(.largeTitle)
				.bold()
				.padding()
			
			TextField("Enter URL", text: $mediaURL)
				.textFieldStyle(.roundedBorder)
				#if os(iOS)
					.textInputAutocapitalization(.never)
				#endif
			
			HStack {
				Button("Open", systemImage: "play") { isPresented.toggle() }
					.disabled(mediaURL.isEmpty)
					.buttonStyle(.borderedProminent)
					.foregroundStyle(Color.accentColor)
				
				Divider()
					.frame(height: 20)
				
				Button("Cancel") { appState.openedSingleStream.toggle() }
					.buttonStyle(.bordered)
					.foregroundStyle(.red)
			}
			.frame(maxWidth: .infinity)
			.padding()
		}
		.navigationTitle("Open Single Media")
		.sheet(isPresented: $isPresented) { playerView }
		.padding()
	}

	var playerView: some View {
		VStack {
			PlayerViewControllerRepresentable(
				name: String(localized: "Single Stream"), url: mediaURL,
				group: String(localized: "Single Stream"),
				playlistName: String(localized: "Single Stream")
			)
			.aspectRatio(16 / 9, contentMode: .fit)
			.cornerRadius(10)
			.padding()

			Button("Cancel") { isPresented.toggle() }
				.buttonStyle(.bordered)
		}
	}
}
