//
//  AddPlaylistView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 15/02/2024.
//

import M3UKit
import SwiftUI

struct AddPlaylistView: View {

	@Environment(\.modelContext) private var context
	@Environment(\.dismiss) private var dismiss
	@Environment(ViewModel.self) private var vm

	private var networkModel: PlaylistFetchingModel {
		PlaylistFetchingModel(vm: vm)
	}

	var body: some View {
		VStack {
			Text("Add Playlist")
				.font(.largeTitle)
				.bold()
				.padding()
			VStack(spacing: 4) {
				TextField(
					"Playlist Name",
					text: Bindable(vm).tempPlaylistName
				)
				.textFieldStyle(.roundedBorder)
				TextField(
					"Playlist URL",
					text: Bindable(vm).tempPlaylistURL
				)
				.textFieldStyle(.roundedBorder)
				.textContentType(.URL)
				.autocorrectionDisabled()
				TextField(
					"Playlist EPG (optional)",
					text: Bindable(vm).tempPlaylistEPG
				)
				.textFieldStyle(.roundedBorder)
				.textContentType(.URL)
				.autocorrectionDisabled()
			}

			HStack(spacing: 4) {
				Button("Add", systemImage: "plus") { addPlaylist() }
					.disabled(
						vm.tempPlaylistName.isEmpty
							|| vm.tempPlaylistURL.isEmpty
					)
					.buttonStyle(.borderedProminent)
					.foregroundStyle(Color.accentColor)
				Button("Cancel") {
					dismiss()
					networkModel.cancel()
				}
				.buttonStyle(.bordered)
				.foregroundStyle(.red)
			}
			.padding()
		}
		.padding()
		.sheet(isPresented: Bindable(vm).isParsing) {
			ProgressView("Adding playlist...").padding()
		}
	}
}

#Preview {
	AddPlaylistView()
		.environment(ViewModel())
}

extension AddPlaylistView {
	private func addPlaylist() {
		Task {
			vm.isParsing.toggle()
			await networkModel.parsePlaylist()
			vm.isParsing.toggle()

			if !vm.parserDidFail {
				context.insert(
					Playlist(
						vm.tempPlaylistName,
						medias: vm.tempPlaylist?.channels ?? [],
						m3uLink: vm.tempPlaylistURL, epgLink: vm.tempPlaylistEPG
					))
				try? context.save()
			}

			dismiss()
			networkModel.cancel()
		}
	}
}
