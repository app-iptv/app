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
	@State private var isAddingFile: Bool = false
	
	private var networkModel: PlaylistFetchingController {
		PlaylistFetchingController(viewModel: viewModel)
	}
	
	var body: some View {
		NavigationStack {
			VStack(spacing: 15) {
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
				}
				
				HStack {
					AsyncButton {
						await addPlaylist(with: nil)
					} label: { _ in
						Label("Add", systemImage: "plus")
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
				
				HStack {
					VStack { Divider() }
					
					Text("or")
						.font(.caption)
						.foregroundStyle(.secondary)
					
					VStack { Divider() }
				}
				.frame(maxWidth: .infinity)
				
				Button("Import from File") {
					isAddingFile.toggle()
				}
				.buttonStyle(.borderless)
				.disabled(viewModel.tempPlaylistName.isEmpty)
			}
			.padding()
			.frame(maxWidth: 500)
			.fileImporter(isPresented: $isAddingFile, allowedContentTypes: [.m3uPlaylist], onCompletion: handleResult)
			.sheet(isPresented: $viewModel.isParsing) { ProgressView("Adding playlist...").padding() }
			.sheet(isPresented: $viewModel.parserDidFail) { ErrorView(viewModel: viewModel) }
		}
	}
}

#Preview {
	AddPlaylistView()
		.environment(AppState())
}

extension AddPlaylistView {
	private func handleResult(_ result: Result<URL, any Error>) {
		Task {
			switch result {
				case .success(let url):
					do {
						if url.startAccessingSecurityScopedResource() {
							let (data, _) = try await URLSession.shared.data(from: url)
									
							await addPlaylist(with: data)
									
							do { url.stopAccessingSecurityScopedResource() }
						} else {
							// Handle error
						}
					} catch {
						print("Unable to read file contents")
						print(error.localizedDescription)
						
						handleError(error)
					}
				case .failure(let error):
					handleError(error)
			}
		}
	}
	
	private func handleError(_ error: Error?) {
		viewModel.parserError = error
		viewModel.parserDidFail = true
	}
	
	private func addPlaylistFromURL() async {
		viewModel.isParsing = true
		await networkModel.parsePlaylist()
		
		guard viewModel.parserError == nil, let tempPlaylist = viewModel.tempPlaylist else { return }
		
		context.insert(
			Playlist(
				viewModel.tempPlaylistName,
				medias: tempPlaylist.channels,
				m3uLink: viewModel.tempPlaylistURL,
				epgLink: viewModel.tempPlaylistEPG
			)
		)
		
		dismiss()
		networkModel.cancel()
	}
	
	private func addPlaylist(with data: Data?) async {
		guard let data = data else { await addPlaylistFromURL(); return }
		
		viewModel.isParsing = true
		await networkModel.addPlaylistFromFile(data: data)
		
		guard viewModel.parserError == nil, let tempPlaylist = viewModel.tempPlaylist else { return }
		
		context.insert(
			Playlist(
				viewModel.tempPlaylistName,
				medias: tempPlaylist.channels,
				m3uLink: viewModel.tempPlaylistURL,
				epgLink: viewModel.tempPlaylistEPG
			)
		)
		
		dismiss()
		networkModel.cancel()
	}
}
