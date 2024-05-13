//
//  AddPlaylistView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 15/02/2024.
//

import SwiftUI
import M3UKit

struct AddPlaylistView: View {
	
	@Environment(\.modelContext) var context
	@Environment(\.dismiss) var dismiss
	
	@State var vm = ViewModel.shared
	
	@State var networkModel = PlaylistFetchingModel()
	
	var body: some View {
		VStack {
			Text("Add Playlist")
				.font(.largeTitle)
				.bold()
				.padding()			
			VStack(spacing: 4) {
				TextField("Playlist Name", text: $vm.tempPlaylistName)
					.textFieldStyle(.plain)
					.padding(10)
					.modifier(ElementViewModifier(for: .top))
				TextField("Playlist URL", text: $vm.tempPlaylistURL)
					.textFieldStyle(.plain)
					.textInputAutocapitalization(.never)
					.textContentType(.URL)
					.autocorrectionDisabled()
					.padding(10)
					.modifier(ElementViewModifier(for: .middle))
				TextField("Playlist EPG (optional)", text: $vm.tempPlaylistEPG)
					.textFieldStyle(.plain)
					.textInputAutocapitalization(.never)
					.textContentType(.URL)
					.autocorrectionDisabled()
					.padding(10)
					.modifier(ElementViewModifier(for: .bottom))
			}
			
			HStack(spacing: 4) {
				Button("Add", systemImage: "plus") { addPlaylist() }
					.disabled(vm.tempPlaylistName.isEmpty || vm.tempPlaylistURL.isEmpty)
					.buttonStyle(.plain)
					.padding(10)
					.modifier(ElementViewModifier(for: .left))
					.foregroundStyle(Color.accentColor)
				Button("Cancel") { dismiss(); networkModel.cancel() }
					.buttonStyle(.plain)
					.padding(10)
					.modifier(ElementViewModifier(for: .right))
					.foregroundStyle(.red)
			}
			.padding()
		}
		.padding()
		.sheet(isPresented: $vm.isParsing) { LoadingView() }
	}
}

extension AddPlaylistView {
	
	private func addPlaylist() {
		Task {
			vm.isParsing.toggle()
			await networkModel.parsePlaylist()
			vm.isParsing.toggle()
			
			if !vm.parserDidFail {
				context.insert(Playlist(vm.tempPlaylistName, medias: vm.tempPlaylist?.channels ?? [], m3uLink: vm.tempPlaylistURL, epgLink: vm.tempPlaylistEPG))
			}
			
			dismiss()
			networkModel.cancel()
		}
	}
}

#Preview {
	AddPlaylistView()
}
