//
//  SettingsView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 24/03/2024.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
	
	@Query private var modelPlaylists: [Playlist]
	
	@AppStorage("FIRST_LAUNCH") private var isFirstLaunch: Bool = false
	@AppStorage("VIEWING_MODE") private var viewingMode: ViewingMode = .regular
	@AppStorage("SELECTED_PLAYLIST_INDEX") private var selectedPlaylist: Int = 0
	
	@State private var vm = ViewModel.shared
	
	@Binding private var isRemovingAll: Bool
	
	internal init(isRemovingAll: Binding<Bool>) {
		self._isRemovingAll = isRemovingAll
	}
	
	var body: some View {
		#if os(macOS)
		NavigationStack {
			content
		}
		#else
		content
		#endif
	}
	
	private var content: some View {
		NavigationStack {
			Form {
				Section {
					Toggle("Show Wecome Screen Again", systemImage: "rectangle.inset.filled", isOn: $isFirstLaunch)
					Picker("Viewing Mode", systemImage: "list.triangle", selection: $viewingMode) {
						ForEach(ViewingMode.allCases) { mode in
							mode.label.tag(mode)
						}
					}
					#if !os(macOS) && !os(tvOS)
					NavigationLink {
						ChangeIconView()
					} label: {
						Label("Change App Icon", systemImage: "app.dashed")
					}
					#endif
				}
				
				#if os(tvOS)
				Section {
					Button("Add Playlist", systemImage: "plus") { vm.isPresented.toggle() }
					Button("Open Stream", systemImage: "play") { vm.openedSingleStream.toggle() }
				}
				
				if !modelPlaylists.isEmpty {
					Section {
						ForEach(modelPlaylists) { playlist in
							Button(playlist.name, systemImage: selectedPlaylist == modelPlaylists.firstIndex(of: playlist) ? "checkmark" : "") { selectedPlaylist = modelPlaylists.firstIndex(of: playlist) ?? 0 }
						}
					}
				}
				#endif
				
				Section {
					Button("Reset Favourites", systemImage: "trash", role: .destructive) { isRemovingAll.toggle() }.foregroundStyle(.red)
				}
				
				Section {
					NavigationLink { AboutView() } label: { Label("About", systemImage: "info.circle") }
				}
			}
			#if !os(tvOS)
			.navigationTitle("Settings")
			#endif
		}
	}
}
