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
	@Environment(AppState.self) private var appState

	@Query private var playlists: [Playlist]

	@AppStorage("FIRST_LAUNCH") private var isFirstLaunch: Bool = false
	@AppStorage("VIEWING_MODE") private var viewingMode: ViewingMode = .regular

	@Binding private var isRemovingAll: Bool

	internal init(isRemovingAll: Binding<Bool>) {
		self._isRemovingAll = isRemovingAll
	}

	var body: some View {
		NavigationStack {
			Form {
				Section {
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
					) { isRemovingAll.toggle() }.foregroundStyle(.red)
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
			#if os(macOS)
				.formStyle(.grouped)
			#endif
		}
	}
}
