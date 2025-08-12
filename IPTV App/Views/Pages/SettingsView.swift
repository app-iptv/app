//
//  SettingsView.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 24/03/2024.
//

import SwiftData
import SwiftUI
import TipKit

struct SettingsView: View {
	@Environment(AppState.self) var appState
	@Environment(\.modelContext) var context
	
	@Query var playlists: [Playlist]

	@AppStorage("FIRST_LAUNCH") var isFirstLaunch: Bool = false
	@AppStorage("VIEWING_MODE") var viewingMode: ViewingMode = .regular

	var body: some View {
		NavigationStack {
			form
				.navigationDestination(for: Playlist.self) { EditPlaylistView($0) }
		}
	}
	
	var form: some View {
		Form {
			#if os(iOS)
				Section("Edit Playlists") {
					ForEach(playlists) { playlist in
						NavigationLink(playlist.name, value: playlist)
							.swipeActions {
								Button("Delete", systemImage: "trash", role: .destructive) { context.delete(playlist) }
							}
					}
				}
			#endif
			
			Section("Customization") {
				Toggle(
					"Show Wecome Screen Again",
					systemImage: "rectangle.inset.filled",
					isOn: $isFirstLaunch)

				Button("Reset Tips", systemImage: "lightbulb.max") {
					try? Tips.resetDatastore()
				}

				Picker(
					"Viewing Mode", systemImage: "list.triangle",
					selection: $viewingMode
				) {
					ForEach(ViewingMode.allCases) { mode in
						mode.label.tag(mode)
					}
				}

				#if os(iOS)
					NavigationLink {
						ChangeIconView()
					} label: {
						Label("Change App Icon", systemImage: "app.dashed")
					}
				#endif
			}

			Section {
				Button(
					"Reset Favourites", systemImage: "trash",
					role: .destructive
				) { appState.isRemovingAll.toggle() }.foregroundStyle(.red)
			}

			Section {
				NavigationLink {
					AboutView()
				} label: {
					Label("About", systemImage: "info.circle")
				}
			}
		}
		.navigationTitle("Settings")
	}
}
