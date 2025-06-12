//
//  ImportPlaylistView.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 15/02/2024.
//

import M3UKit
import SwiftUI

struct ImportPlaylistView: View {
	@Environment(\.modelContext) private var context
	@Environment(\.dismiss) private var dismiss
	@Environment(AppState.self) private var appState
	
	@State private var viewModel: AddPlaylistViewModel = AddPlaylistViewModel()
	
	var body: some View {
		NavigationStack {
			VStack(spacing: 15) {
				VStack {
					Text("Add Playlist")
						.font(.largeTitle)
						.bold()
						.padding()
					
					TextField("Playlist Name", text: $viewModel.playlist.name)
						.textFieldStyle(.roundedBorder)
						
					if let _ = viewModel.fileData {
						HStack {
							VStack { Divider() }
							
							Text("FILE ADDED")
								.font(.caption)
								.foregroundStyle(.secondary)
							
							VStack { Divider() }
						}
						.frame(maxWidth: .infinity)
					} else {
						TextField("Playlist URL", text: $viewModel.playlist.m3uLink)
							.textFieldStyle(.roundedBorder)
							.textContentType(.URL)
							.autocorrectionDisabled()
							#if os(iOS)
							.autocapitalization(.none)
							#endif
					}
					
					TextField("Playlist EPG (optional)", text: $viewModel.playlist.epgLink)
						.textFieldStyle(.roundedBorder)
						.textContentType(.URL)
						.autocorrectionDisabled()
						#if os(iOS)
						.autocapitalization(.none)
						#endif
				}
				
				HStack {
					AsyncButton {
						await viewModel.addPlaylist(with: viewModel.fileData)
						dismiss()
					} label: { isLoading in
						if isLoading {
							return AnyView(ProgressView())
						} else {
							return AnyView(Label("Add", systemImage: "plus"))
						}
					}
					.disabled(
						viewModel.playlist.name.isEmpty ||
						(viewModel.fileData == nil ? viewModel.playlist.m3uLink.isEmpty : false)
					)
					.buttonStyle(.borderedProminent)
					
					Divider()
						.frame(height: 20)
					
					Button("Cancel") {
						dismiss()
						viewModel.cancel()
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
					viewModel.isAddingFile.toggle()
				}
				.buttonStyle(.borderless)
				.foregroundStyle(.accent)
			}
			.padding()
			.frame(maxWidth: 500)
			.fileImporter(isPresented: $viewModel.isAddingFile, allowedContentTypes: [.m3uPlaylist], onCompletion: viewModel.handleResult)
			.sheet(isPresented: $viewModel.parserDidFail) { ErrorView(viewModel: viewModel) }
		}
	}
}

#Preview {
	ImportPlaylistView()
		.environment(AppState())
}
