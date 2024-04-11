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
	
	@State private var mediaURL: String = ""
	
	@Bindable var vm: ViewModel
	
	init(_ vm: ViewModel) { self.vm = vm }
	
	@State private var isPresented: Bool = false
	
    var body: some View {
		VStack {
			Text("Open Single media")
				.font(.largeTitle)
				.bold()
				.padding()
			
			TextField("Enter URL", text: $mediaURL)
				.textFieldStyle(.roundedBorder)
				.textInputAutocapitalization(.never)
			
			HStack(spacing: 10) {
				Button("Open", systemImage: "play") { isPresented.toggle() }
					.disabled(mediaURL.isEmpty)
					.buttonStyle(.borderedProminent)
				Button("Cancel") { vm.openedSingleStream.toggle() }
					.buttonStyle(.bordered)
			}
			.padding()
		}
		.navigationTitle("Open Single media")
		.sheet(isPresented: $isPresented) { playerView }
		.padding()
    }
	
	var playerView: some View {
		VStack {
			SinglePlayerView(name: String(localized: "Single Stream"), url: mediaURL, group: String(localized: "Single Stream"), playlistName: String(localized: "Single Stream"))
			.aspectRatio(16/9, contentMode: .fit)
			.cornerRadius(10)
			.padding()
			
			Button("Cancel") { isPresented.toggle() }
				.buttonStyle(.bordered)
		}
	}
}
