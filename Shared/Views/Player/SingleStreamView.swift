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
	
	@Environment(ViewModel.self) private var vm
	
	@State private var isPresented: Bool = false
	
	var body: some View {
		@Bindable var vm = vm
		
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
				#if os(iOS)
				.textInputAutocapitalization(.never)
				#endif
				.padding(10)
				.modifier(ElementViewModifier(for: .content))
			
			HStack(spacing: 4) {
				Button("Open", systemImage: "play") { isPresented.toggle() }
					.disabled(mediaURL.isEmpty)
					.buttonStyle(.plain)
					.padding(10)
					.modifier(ElementViewModifier(for: .left))
					.foregroundStyle(Color.accentColor)
				Button("Cancel") { vm.openedSingleStream.toggle() }
					.buttonStyle(.plain)
					.padding(10)
					.modifier(ElementViewModifier(for: .right))
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
			PlayerViewControllerRepresentable(name: String(localized: "Single Stream"), url: mediaURL, group: String(localized: "Single Stream"), playlistName: String(localized: "Single Stream"))
				.aspectRatio(16/9, contentMode: .fit)
				.cornerRadius(10)
				.padding()
			
			Button("Cancel") { isPresented.toggle() }
				.buttonStyle(.bordered)
		}
	}
}
