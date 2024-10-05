//
//  IPTVApp.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 31/12/2023.
//

import AVKit
import M3UKit
import SwiftData
import SwiftUI
import TipKit

@main
struct IPTVApp: App {

	#if os(iOS)
		@UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
	#endif

	#if !os(tvOS)
		@Environment(\.openWindow) private var openWindow
	#endif

	@Query private var playlists: [Playlist]

	@AppStorage("FIRST_LAUNCH") private var isFirstLaunch: Bool = true
	@AppStorage("FAVORITED_CHANNELS") private var favourites: [Media] = []
	@AppStorage("VIEWING_MODE") private var viewingMode: ViewingMode = .regular

	@State private var vm = ViewModel()
	@State private var isRemovingAll: Bool = false
	@State private var epgFetchingModel: EPGFetchingModel = EPGFetchingModel()

	#if !os(tvOS)
		private var commands: some Commands {
			Group {
				CommandGroup(replacing: .newItem) {
					Button("New Playlist", systemImage: "plus") {
						vm.isPresented.toggle()
					}.keyboardShortcut("N", modifiers: [.command])

					Button("Open Single Stream", systemImage: "play") {
						vm.openedSingleStream.toggle()
					}.keyboardShortcut("O", modifiers: [.command])

					#if os(macOS)
						Divider()

						Button("New Window") {
							openWindow(id: "MAIN_WINDOW")
						}.keyboardShortcut("N", modifiers: [.command, .shift])
					#endif
				}

				#if os(macOS)
					CommandGroup(replacing: .appInfo) {
						Button("About IPTV App", systemImage: "info.circle") {
							openWindow(id: "ABOUT_WINDOW")
						}.keyboardShortcut("A", modifiers: [.command])
					}
				#endif
			}
		}
	#endif

	var body: some Scene {
		WindowGroup(id: "MAIN_WINDOW") {
			ContentView(isRemovingAll: $isRemovingAll)
				.task { try? Tips.configure() }
		}
		.modelContainer(SwiftDataCoordinator.shared.persistenceContainer)
		.environment(epgFetchingModel)
		.environment(vm)
		.onChange(of: vm.selectedPlaylist) {
			epgFetchingModel = EPGFetchingModel(epg: vm.selectedPlaylist?.epgLink, viewModel: vm)
		}
		#if !os(tvOS)
			.commands { commands }
		#endif

		#if os(macOS)
			Window("About IPTV App", id: "ABOUT_WINDOW") {
				AboutView()
					.padding()
			}
			.windowResizability(.contentSize)
			.windowStyle(.hiddenTitleBar)

			Settings {
				SettingsView(isRemovingAll: $isRemovingAll)
					.frame(width: 500, height: 300)
			}
			.environment(epgFetchingModel)
			.environment(vm)
			.windowStyle(.hiddenTitleBar)
		#endif
	}
}
