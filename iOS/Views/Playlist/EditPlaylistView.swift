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
	
	init(_ playlist: Playlist) { self.playlist = playlist }
	
    var body: some View {
		VStack {
			Text("Edit \"\(playlist.name)\"")
				.font(.largeTitle)
				.bold()
			
//			HStack(spacing: 10) {
//				TextField("Playlist Name", text: $newName)
//					.textFieldStyle(.roundedBorder)
//				Button("Done", systemImage: "checkmark.circle", role: .cancel) {
//					playlist.name = newName
//					dismiss()
//				}
//				.buttonStyle(.bordered)
//			}
			HStack(spacing: 4) {
				TextField("Playlist Name", text: $newName)
					.textFieldStyle(.plain)
					.frame(height: 20)
					.padding(10)
					.background(.ultraThickMaterial, in: UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 8, bottomLeading: 8, bottomTrailing: 2.5, topTrailing: 2.5), style: .circular))
				Button("Done", systemImage: "checkmark.circle", role: .cancel) {
					playlist.name = newName
					dismiss()
				}
				.buttonStyle(.plain)
				.disabled(newName.isEmpty)
				.foregroundStyle(Color.accentColor)
				.frame(height: 20)
				.padding(10)
				.background(.ultraThickMaterial, in: UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 2.5, bottomLeading: 2.5, bottomTrailing: 8, topTrailing: 8), style: .circular))
			}
		}
		.padding()
		.onAppear { newName = playlist.name }
    }
}
