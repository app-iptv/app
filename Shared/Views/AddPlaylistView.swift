//
//  AddPlaylistView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 15/02/2024.
//

import SwiftUI
import M3UKit

struct AddPlaylistView: View {
	
	@ObservedObject var vm = ViewModel()
	@Environment(\.modelContext) var context
	
	@Binding var isPresented: Bool
	@Binding var isParsing: Bool
	@Binding var parserDidFail: Bool
	@Binding var parserError: String
	
	let parser = PlaylistParser()
	
	// MARK: ParsePlaylistFunc
	func parsePlaylist() async {
		print("Parsing Playlist...")
		await withCheckedContinuation { continuation in
			parser.parse(URL(string: vm.tempPlaylistURL)!) { result in
				switch result {
					case .success(let playlist):
						print("Success")
						vm.tempPlaylist = playlist
						parserDidFail = false
						continuation.resume()
					case .failure(let error):
						print("Error: \(error)")
						parserError = "\(error.localizedDescription)"
						parserDidFail = true
						continuation.resume()
				}
			}
			isParsing.toggle()
			isPresented.toggle()
		}
	}
	
	// MARK: AddPlaylistFunc
	func addPlaylist() {
		Task {
			await parsePlaylist()
			
			isParsing.toggle()
			
			if parserDidFail {
				vm.tempPlaylistName = ""
				vm.tempPlaylistURL = ""
				vm.tempPlaylist = Playlist(medias: [])
			} else {
				context.insert(ModelPlaylist(id: UUID(), name: vm.tempPlaylistName, medias: vm.tempPlaylist.medias, m3uLink: vm.tempPlaylistURL))
				vm.tempPlaylistName = ""
				vm.tempPlaylistURL = ""
				vm.tempPlaylist = Playlist(medias: [])
			}
		}
	}
	
	// MARK: CancelPlaylistFunc
	func cancel() {
		isPresented.toggle()
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
			}.padding()
		}
		.padding()
	}
}
