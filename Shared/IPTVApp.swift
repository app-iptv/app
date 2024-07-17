//
//  IPTVApp.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 31/12/2023.
//

import SwiftUI
import M3UKit
import SwiftData
import AVKit
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
	@AppStorage("SELECTED_PLAYLIST_INDEX") private var selectedPlaylist: Int = 0
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
		}
		.modelContainer(SwiftDataCoordinator.shared.persistenceContainer)
		.environment(epgFetchingModel)
		.environment(vm)
		.onChange(of: vm.selectedPlaylist) { epgFetchingModel = EPGFetchingModel(epg: vm.selectedPlaylist?.epgLink, viewModel: vm) }
		#if !os(tvOS)
		.commands { commands }
		#endif
		
		#if os(macOS)
		Window("About IPTV App", id: "ABOUT_WINDOW") { AboutView() }
		
		Settings { SettingsView(isRemovingAll: $isRemovingAll) }.windowStyle(.hiddenTitleBar)
		#endif
	}
	
	init() {
		do {
			try Tips.configure()
		} catch {
			dump(error)
		}
	}
}

#if os(iOS)
class AppDelegate: UIResponder, UIApplicationDelegate {
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		let session = AVAudioSession.sharedInstance()
		
		do {
			try session.setCategory(.playback, mode: .moviePlayback)
		} catch {
			print(error.localizedDescription)
		}
		
		return true
	}
}
#endif
