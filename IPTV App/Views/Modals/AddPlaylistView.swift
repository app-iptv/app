//
//  AddPlaylistView.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 15/02/2024.
//

import M3UKit
import SwiftUI

struct AddPlaylistView: View {

	@Environment(\.modelContext) private var context
	@Environment(\.dismiss) private var dismiss
	@Environment(AppState.self) private var appState
	
	@State private var viewModel = AddPlaylistViewModel()

	private var networkModel: PlaylistFetchingController {
		PlaylistFetchingController(viewModel: viewModel)
	}

	var body: some View {
		VStack {
			Text("Add Playlist")
				.font(.largeTitle)
				.bold()
				.padding()
			
			TextField(
				"Playlist Name",
				text: $viewModel.tempPlaylistName
			)
			.textFieldStyle(.roundedBorder)
			
			TextField(
				"Playlist URL",
				text: $viewModel.tempPlaylistURL
			)
			.textFieldStyle(.roundedBorder)
			.textContentType(.URL)
			.autocorrectionDisabled()
			#if os(iOS)
			.autocapitalization(.none)
			#endif
			
			TextField(
				"Playlist EPG (optional)",
				text: $viewModel.tempPlaylistEPG
			)
			.textFieldStyle(.roundedBorder)
			.textContentType(.URL)
			.autocorrectionDisabled()
			#if os(iOS)
			.autocapitalization(.none)
			#endif

			HStack {
				AsyncButton("Add", systemImage: "plus") {
					await addPlaylist()
				}
				.disabled(
					viewModel.tempPlaylistName.isEmpty ||
					viewModel.tempPlaylistURL.isEmpty
				)
				.buttonStyle(.borderedProminent)
				
				Divider()
					.frame(height: 20)
				
				Button("Cancel") {
					dismiss()
					networkModel.cancel()
				}
				.buttonStyle(.bordered)
				.foregroundStyle(.red)
			}
			.frame(maxWidth: .infinity)
			.padding()
		}
		.padding()
		.sheet(isPresented: $viewModel.isParsing) { ProgressView("Adding playlist...").padding() }
		.sheet(isPresented: $viewModel.parserDidFail) { ErrorView(viewModel: viewModel) }
	}
}

#Preview {
	AddPlaylistView()
		.environment(AppState())
}

extension AddPlaylistView {
	private func addPlaylist() async {
		viewModel.isParsing = true
		await networkModel.parsePlaylist()
		viewModel.isParsing = false
		
		if viewModel.parserError == nil {
			context.insert(
				Playlist(
					viewModel.tempPlaylistName,
					medias: viewModel.tempPlaylist?.channels ?? [],
					m3uLink: viewModel.tempPlaylistURL,
					epgLink: viewModel.tempPlaylistEPG
				)
			)
		}
		
		dismiss()
		networkModel.cancel()
	}
}
