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
	
	@Bindable var vm: ViewModel
	
	init(_ vm: ViewModel) { self.vm = vm }
	
	let parser = PlaylistParser()
	
	var body: some View {
		VStack {
			Text("Add Playlist")
				.font(.largeTitle)
				.bold()
				.padding()
			
			VStack {
				TextField("Playlist Name", text: $vm.tempPlaylistName)
					#if !os(tvOS)
					.textFieldStyle(.roundedBorder)
					#endif
				TextField("Playlist URL", text: $vm.tempPlaylistURL)
					#if !os(tvOS)
					.textFieldStyle(.roundedBorder)
					#endif
					.textInputAutocapitalization(.never)
			}
			
			HStack(spacing: 10) {
				Button("Add", systemImage: "plus") { addPlaylist() }
					.disabled(vm.tempPlaylistName.isEmpty || vm.tempPlaylistURL.isEmpty)
					.buttonStyle(.borderedProminent)
				
				Button("Cancel") { cancel() }
					.buttonStyle(.bordered)
			}
			.padding()
		}
		.padding()
	}
}

extension AddPlaylistView {
	
	private func parsePlaylist() async {
		print("Parsing Playlist...")
		await withCheckedContinuation { continuation in
			parser.parse(URL(string: vm.tempPlaylistURL)!) { result in
				switch result {
					case .success(let playlist):
						print("Success")
						vm.tempPlaylist = playlist
						vm.parserDidFail = false
						vm.isParsing.toggle()
						continuation.resume()
					case .failure(let error):
						print("Error: \(error)")
						vm.parserError = "\(error.localizedDescription)"
						vm.parserDidFail = true
						vm.isParsing.toggle()
						continuation.resume()
				}
			}
			vm.isPresented.toggle()
		}
	}
	
	private func addPlaylist() {
		Task {
			vm.isParsing.toggle()
			
			await parsePlaylist()
			
			if vm.parserDidFail {
				vm.tempPlaylistName = ""
				vm.tempPlaylistURL = ""
				vm.tempPlaylist = Playlist(medias: [])
			} else {
				context.insert(ModelPlaylist(vm.tempPlaylistName, medias: vm.tempPlaylist.medias, m3uLink: vm.tempPlaylistURL))
				vm.tempPlaylistName = ""
				vm.tempPlaylistURL = ""
				vm.tempPlaylist = Playlist(medias: [])
			}
		}
	}

	private func cancel() {
		dismiss()
		vm.tempPlaylist = Playlist(medias: [])
		vm.tempPlaylistURL = ""
		vm.tempPlaylistName = ""
	}
	
}
