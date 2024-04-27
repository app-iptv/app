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
	
	@State var vm = ViewModel.shared
	
	@State private var isPresented: Bool = false
	
    var body: some View {
		VStack {
			Text("Open Single Media")
				.font(.largeTitle)
				.bold()
				.padding()
			
//			TextField("Enter URL", text: $mediaURL)
//				.textFieldStyle(.roundedBorder)
//				.textInputAutocapitalization(.never)
//			
//			HStack(spacing: 10) {
//				Button("Open", systemImage: "play") { isPresented.toggle() }
//					.disabled(mediaURL.isEmpty)
//					.buttonStyle(.borderedProminent)
//				Button("Cancel") { vm.openedSingleStream.toggle() }
//					.buttonStyle(.bordered)
//			}
//			.padding()
			
			TextField("Enter URL", text: $mediaURL)
				.textFieldStyle(.plain)
				.textInputAutocapitalization(.never)
				.padding(10)
				.background(.ultraThickMaterial, in: RoundedRectangle(cornerRadius: 8))
			
			HStack(spacing: 4) {
				Button("Open", systemImage: "play") { isPresented.toggle() }
					.disabled(mediaURL.isEmpty)
					.buttonStyle(.plain)
					.padding(10)
					.background(.ultraThickMaterial, in: UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 8, bottomLeading: 8, bottomTrailing: 2.5, topTrailing: 2.5), style: .circular))
					.foregroundStyle(Color.accentColor)
				Button("Cancel") { vm.openedSingleStream.toggle() }
					.buttonStyle(.plain)
					.padding(10)
					.background(.ultraThickMaterial, in: UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 2.5, bottomLeading: 2.5, bottomTrailing: 8, topTrailing: 8), style: .circular))
					.foregroundStyle(.red)
			}
			.padding()
		}
		.navigationTitle("Open Single Media")
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
