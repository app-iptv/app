//
//  SettingsView.swift
//  IPTV TV
//
//  Created by Pedro Cordeiro on 12/03/2024.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
	
	@Bindable var vm: ViewModel
	
	@Environment(\.modelContext) var context
	@Query var modelPlaylists: [ModelPlaylist]
	
	var body: some View {
		NavigationStack {
			Form {
				Button("New Playlist", systemImage: "plus") { vm.isPresented.toggle() }
				NavigationLink {
					List(modelPlaylists) { playlist in
						PlaylistCellView(playlist: playlist)
					}
				} label: {
					Label("Delete Playlist", systemImage: "trash")
				}
				.foregroundStyle(.red)
			}
		}
	}
}

struct PlaylistCellView: View {
	@State var isPresented: Bool = false
	
	@Environment(\.modelContext) var context
	
	var playlist: ModelPlaylist
	
	var body: some View {
		Button(playlist.name, role: .destructive) {
			isPresented.toggle()
		}
		.alert("Confirm Deletion", isPresented: $isPresented) {
			Button("Delete", systemImage: "trash", role: .destructive) {
				context.delete(playlist)
			}
			Button("Cancel", systemImage: "xmark.circle", role: .cancel) { }
		}
	}
}
