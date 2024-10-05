//
//  SingleStreamView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 16/02/2024.
//

import AVKit
import M3UKit
import SwiftUI

struct SingleStreamView: View {

	@State private var mediaURL: String = ""

	@Environment(ViewModel.self) private var vm

	@State private var isPresented: Bool = false

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

			HStack(spacing: 4) {
				Button("Open", systemImage: "play") { isPresented.toggle() }
					.disabled(mediaURL.isEmpty)
					.buttonStyle(.borderedProminent)
					.foregroundStyle(Color.accentColor)
				Button("Cancel") { vm.openedSingleStream.toggle() }
					.buttonStyle(.bordered)
					.foregroundStyle(.red)
			}
			.padding()
		}
		.navigationTitle("Open Single Media")
		.sheet(isPresented: $isPresented) { playerView }
		.padding()
	}

	private var playerView: some View {
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
