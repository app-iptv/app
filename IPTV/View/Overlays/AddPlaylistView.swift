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
	
	let parser = PlaylistParser()
	
	var isDisabled: Bool {
		guard vm.tempPlaylistName != "" else { return true }
		guard vm.tempPlaylistURL != "" else { return true}
		
		return false
	}
	
	// MARK: ParsePlaylistFunc
	func parsePlaylist() async {
		print("Parsing Playlist...")
		await withCheckedContinuation { continuation in
			isParsing.toggle()
			isPresented.toggle()
			parser.parse(URL(string: vm.tempPlaylistURL)!) { result in
				switch result {
					case .success(let playlist):
						print("Success")
						vm.tempPlaylist = playlist
						vm.parserDidFail = false
						continuation.resume()
					case .failure(let error):
						print("Error: \(error)")
						vm.parserError = "\(error.localizedDescription)"
						vm.parserDidFail = true
						continuation.resume()
				}
			}
		}
	}
	
	// MARK: AddPlaylistFunc
	func addPlaylist() {
		Task {
			await parsePlaylist()
			
			isParsing.toggle()
			
			if vm.parserDidFail {
				vm.tempPlaylistName = ""
				vm.tempPlaylistURL = ""
				vm.tempPlaylist = Playlist(medias: [])
			} else {
				context.insert(SavedPlaylist(id: UUID(), name: vm.tempPlaylistName, playlist: vm.tempPlaylist, m3uLink: vm.tempPlaylistURL))
				vm.tempPlaylistName = ""
				vm.tempPlaylistURL = ""
				vm.tempPlaylist = Playlist(medias: [])
			}
		}
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
					#elseif os(iOS)
					.textInputAutocapitalization(.never)
					#endif
			}
			
			HStack(alignment: .center) {
				Button("Add") {
					addPlaylist()
				}
				.disabled(isDisabled)
				.buttonStyle(.borderedProminent)
				
				Spacer()
					.frame(width: 20)
				
				Button("Cancel") {
					isPresented.toggle()
					vm.tempPlaylist = Playlist(medias: [])
					vm.tempPlaylistURL = ""
					vm.tempPlaylistName = ""
				}
			}.padding()
		}
		#if os(macOS)
		.frame(width: 300, height: 300)
		#endif
		.padding()
	}
}
