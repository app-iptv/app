//
//  EditPlaylistView.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 15/02/2024.
//

import SwiftUI
import SwiftData

struct EditPlaylistView: View {
	@Environment(\.dismiss) private var dismiss
	@Environment(\.modelContext) private var modelContext
	
	@Bindable private var playlist: Playlist

	@State private var newName: String = ""
	@State private var newEPG: String = ""
	@State private var isPresented: Bool = false

	init(_ playlist: Playlist) { self.playlist = playlist }

	var body: some View {
		VStack(spacing: 15) {
			VStack {
				Text("Edit \"\(playlist.name)\"")
					.font(.largeTitle)
					.bold()
					.padding()
				
				TextField("Playlist Name", text: $newName)
					.textFieldStyle(.roundedBorder)
				
				TextField("Playlist EPG", text: $newEPG)
					.textFieldStyle(.roundedBorder)
					.textContentType(.URL)
					.autocorrectionDisabled()
					#if os(iOS)
					.autocapitalization(.none)
					#endif
			}
			
			HStack {
				Button("Done", systemImage: "checkmark.circle", role: .cancel) {
					playlist.name = newName
					playlist.epgLink = newEPG
					dismiss()
				}
				.buttonStyle(.bordered)
				.disabled(newName.isEmpty)
				
				Divider()
					.frame(height: 20)
				
				Button("Delete", systemImage: "trash", role: .destructive) {
					isPresented.toggle()
				}
				.buttonStyle(.bordered)
				.foregroundStyle(.red)
			}
			.frame(maxWidth: .infinity)
		}
		.padding()
		.frame(maxWidth: 500)
		.onAppear {
			newName = playlist.name
			newEPG = playlist.epgLink
		}
		.confirmationDialog("Delete \"\(playlist.name)\"?", isPresented: $isPresented) {
			Button("Delete \"\(playlist.name)\"", role: .destructive) {
				modelContext.delete(playlist)
				dismiss()
			}
			
			Button("Cancel", role: .cancel) { }
		}
	}
}

#Preview {
	EditPlaylistView(Playlist("Preview", medias: [], m3uLink: "https://epg-link.m3u.com/"))
}
