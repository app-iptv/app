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
	
	init(_ playlist: ModelPlaylist) {
		self.playlist = playlist
	}
	
    var body: some View {
		VStack {
			VStack(spacing: 5) {
				Text("Edit Playlist")
					.font(.largeTitle)
					.bold()
				Text(playlist.name)
					.font(.footnote)
			}
			
			HStack(spacing: 10) {
				TextField("Playlist Name", text: $playlist.name)
					.textFieldStyle(.roundedBorder)
				Button("Done", systemImage: "checkmark.circle", role: .cancel) { dismiss() }
			}
			.padding()
		}
		.padding()
    }
}
