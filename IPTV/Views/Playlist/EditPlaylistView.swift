//
//  EditPlaylistView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 15/02/2024.
//

import SwiftUI

struct EditPlaylistView: View {
	
	@Bindable var playlist: ModelPlaylist
	@Binding var isEditing: Bool
	
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
				Button("Done", systemImage: "checkmark.circle", role: .cancel) { isEditing.toggle() }
			}
			.padding()
		}
		.padding()

    }
}
