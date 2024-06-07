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

@main
struct IPTVApp: App {
	
	@UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
	
	#if !os(tvOS)
	@Environment(\.openWindow) private var openWindow
	#endif
	
	@AppStorage("FIRST_LAUNCH") private var isFirstLaunch: Bool = true
	@AppStorage("FAVORITED_CHANNELS") private var favourites: [Media] = []
	@AppStorage("SELECTED_PLAYLIST_INDEX") private var selectedPlaylist: Int = 0
	@AppStorage("VIEWING_MODE") private var viewingMode: ViewingMode = .regular
	
	@State private var vm = ViewModel.shared
	@State private var isRemovingAll: Bool = false
	
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
			}
			
			#if targetEnvironment(macCatalyst)
			CommandGroup(replacing: .appInfo) {
				Button("About IPTV App", systemImage: "info.circle") {
					openWindow(id: "ABOUT_WINDOW")
				}.keyboardShortcut("A", modifiers: [.command])
			}
			
			CommandGroup(replacing: .appVisibility) {
				Button("New Window") {
					openWindow(id: "MainWindow")
				}.keyboardShortcut("N", modifiers: [.command, .option])
			}
			#endif
			
			CommandGroup(replacing: .appSettings) {
				Menu("Settings", systemImage: "gear") {
					Button("Show Tips Again") {
						isFirstLaunch.toggle()
					}.keyboardShortcut("T", modifiers: [.command])
					
					Picker("Viewing Mode", systemImage: "list.triangle", selection: $viewingMode) {
						ForEach(ViewingMode.allCases) { mode in
							mode.label.tag(mode)
						}
					}
					
					Button("Reset Favourites", systemImage: "trash", role: .destructive) {
						isRemovingAll.toggle()
					}.keyboardShortcut(.delete, modifiers: .all)
					
					#if targetEnvironment(macCatalyst)
//					Button("Tip Jar", systemImage: "hands.clap") {
//						openWindow(id: "TIP_JAR_WINDOW")
//					}.keyboardShortcut("T", modifiers: [.command, .shift])
					
					Button("Open Legacy Settings", systemImage: "gear") {
						openWindow(id: "SETTINGS_WINDOW")
					}
					#endif
				}
			}
		}
	}
	#endif
	
	var body: some Scene {
		WindowGroup(id: "MainWindow") {
			ContentView(isRemovingAll: $isRemovingAll)
		}
		.modelContainer(SwiftDataCoordinator.shared.persistenceContainer)
		.onChange(of: selectedPlaylist) { old, new in
			guard old != new else { return }
			
			#if DEBUG
			print("Reloading: new = \(new), old = \(old)")
			#endif
			
			EPGFetchingModel.shared = EPGFetchingModel()
		}
		#if !os(tvOS)
		.commands { commands }
		#endif
		
		#if targetEnvironment(macCatalyst)
		WindowGroup(id: "ABOUT_WINDOW") { AboutView() }
		
		WindowGroup("Settings", id: "SETTINGS_WINDOW") { SettingsView(isRemovingAll: $isRemovingAll) }
		#endif
	}
}

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
