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
	
	@Bindable var vm: ViewModel
	
	init(_ vm: ViewModel) {
		self.vm = vm
	}
	
	let parser = PlaylistParser()
	
	// MARK: ParsePlaylistFunc
	private func parsePlaylist() async {
		print("Parsing Playlist...")
		await withCheckedContinuation { continuation in
			parser.parse(vm.tempPlaylistURL) { result in
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
	
	// MARK: AddPlaylistFunc
	private func addPlaylist() {
		Task {
			vm.isParsing.toggle()
			
			await parsePlaylist()
			
			if vm.parserDidFail {
				vm.tempPlaylistName = ""
				vm.tempPlaylistURL = ""
				vm.tempPlaylist = Playlist(medias: [])
			} else {
				context.insert(ModelPlaylist(UUID(), vm.tempPlaylistName, vm.tempPlaylist.medias, vm.tempPlaylistURL))
				vm.tempPlaylistName = ""
				vm.tempPlaylistURL = ""
				vm.tempPlaylist = Playlist(medias: [])
			}
		}
	}
	
	// MARK: CancelPlaylistFunc
	private func cancel() {
		vm.isPresented.toggle()
		vm.tempPlaylist = Playlist(medias: [])
		vm.tempPlaylistURL = ""
		vm.tempPlaylistName = ""
	}
	
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
			
			HStack(spacing: 20) {
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
