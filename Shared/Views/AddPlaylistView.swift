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
	
	let decoder = M3UDecoder()
	
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
		.sheet(isPresented: $vm.isParsing) { LoadingView() }
	}
}

extension AddPlaylistView {
	
	private func parsePlaylist() async {
		let url = URL(string: vm.tempPlaylistURL)!
		
		do {
			let m3u = try decoder.decode(Data(contentsOf: url))
			
			vm.tempPlaylist = m3u
		} catch {
			print(error.localizedDescription)
			vm.parserError = error.localizedDescription
			vm.parserDidFail = true
		}
	}
	
	private func addPlaylist() {
		Task {
			vm.isParsing.toggle()
			await parsePlaylist()
			vm.isParsing.toggle()
			
			if !vm.parserDidFail {
				context.insert(Playlist(vm.tempPlaylistName, medias: vm.tempPlaylist?.channels ?? [], m3uLink: vm.tempPlaylistURL))
			}
			
			cancel()
		}
	}

	private func cancel() {
		dismiss()
		vm.tempPlaylist = nil
		vm.tempPlaylistURL = ""
		vm.tempPlaylistName = ""
	}
	
}
