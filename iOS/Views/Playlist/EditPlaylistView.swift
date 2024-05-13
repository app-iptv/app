//
//  EditPlaylistView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 15/02/2024.
//

import SwiftUI

struct EditPlaylistView: View {
	
	@Environment(\.dismiss) private var dismiss
	
	@Bindable var playlist: Playlist
	
	@State var newName: String = ""
	@State var newEPG: String = ""
	
	init(_ playlist: Playlist) { self.playlist = playlist }
	
    var body: some View {
		VStack {
			Text("Edit \"\(playlist.name)\"")
				.font(.largeTitle)
				.bold()
			
			HStack(spacing: 4) {
				VStack(spacing: 4) {
					TextField("Playlist Name", text: $newName)
						.textFieldStyle(.plain)
						.frame(height: 20)
						.padding(10)
						.modifier(ElementViewModifier(for: .topLeft))
					TextField("Playlist Name", text: $newEPG)
						.textFieldStyle(.plain)
						.textInputAutocapitalization(.never)
						.textContentType(.URL)
						.autocorrectionDisabled()
						.frame(height: 20)
						.padding(10)
						.modifier(ElementViewModifier(for: .bottomLeft))
				}
				Button("Done", systemImage: "checkmark.circle", role: .cancel) {
					playlist.name = newName
					playlist.epgLink = newEPG
					dismiss()
				}
				.buttonStyle(.plain)
				.disabled(newName.isEmpty)
				.foregroundStyle(Color.accentColor)
				.frame(height: 64)
				.padding(10)
				.modifier(ElementViewModifier(for: .right))
			}
		}
		.padding()
		.onAppear { newName = playlist.name; newEPG = playlist.epgLink }
    }
}
