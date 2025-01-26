//
//  AddPlaylistView.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 24/01/2025.
//

import SwiftUI

struct AddPlaylistView: View {
	var body: some View {
		SwiftUI.TabView {
			ImportPlaylistView()
				.tabItem { Label("Import", systemImage: "square.and.arrow.down.fill") }
			CreatePlaylistView()
				.tabItem { Label("Create", systemImage: "rectangle.fill.on.rectangle.angled.fill") }
		}
	}
}

#Preview {
	AddPlaylistView()
		.environment(AppState())
}
