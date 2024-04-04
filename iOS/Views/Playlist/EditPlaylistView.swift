//
//  EditPlaylistView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 15/02/2024.
//

import SwiftUI

struct EditPlaylistView: View {
	
	@Environment(\.dismiss) private var dismiss
	
	@Bindable var playlist: ModelPlaylist
	
	@State var newName: String = ""
	
	init(_ playlist: ModelPlaylist) { self.playlist = playlist }
	
    var body: some View {
		VStack {
			Text("Edit \"\(playlist.name)\"")
				.font(.largeTitle)
				.bold()
			
			HStack(spacing: 10) {
				TextField("Playlist Name", text: $newName)
					.textFieldStyle(.roundedBorder)
				Button("Done", systemImage: "checkmark.circle", role: .cancel) {
					playlist.name = newName
					dismiss()
				}
				.buttonStyle(.bordered)
			}
		}
		.padding()
		.onAppear { newName = playlist.name }
    }
}
