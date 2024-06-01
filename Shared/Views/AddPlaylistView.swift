//
//  AddPlaylistView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 15/02/2024.
//

import SwiftUI
import M3UKit

struct AddPlaylistView: View {
	
	@Environment(\.modelContext) private var context
	@Environment(\.dismiss) private var dismiss
	
	@State private var vm = ViewModel.shared
	
	@State private var networkModel = PlaylistFetchingModel()
	
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
				#if !os(tvOS)
					.modifier(ElementViewModifier(for: .top))
				#endif
				TextField("Playlist URL", text: $vm.tempPlaylistURL)
					.textFieldStyle(.plain)
					.textInputAutocapitalization(.never)
					.textContentType(.URL)
					.autocorrectionDisabled()
					.padding(10)
				#if !os(tvOS)
					.modifier(ElementViewModifier(for: .middle))
				#endif
				TextField("Playlist EPG (optional)", text: $vm.tempPlaylistEPG)
					.textFieldStyle(.plain)
					.textInputAutocapitalization(.never)
					.textContentType(.URL)
					.autocorrectionDisabled()
					.padding(10)
				#if !os(tvOS)
					.modifier(ElementViewModifier(for: .bottom))
				#endif
			}
			
			HStack(spacing: 4) {
				Button("Add", systemImage: "plus") { addPlaylist() }
					.disabled(vm.tempPlaylistName.isEmpty || vm.tempPlaylistURL.isEmpty)
					.buttonStyle(.plain)
				#if os(tvOS)
					.padding(15)
				#else
					.padding(10)
				#endif
					.modifier(ElementViewModifier(for: .left))
					.foregroundStyle(Color.accentColor)
				Button("Cancel") { dismiss(); networkModel.cancel() }
					.buttonStyle(.plain)
				#if os(tvOS)
					.padding(15)
				#else
					.padding(10)
				#endif
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
