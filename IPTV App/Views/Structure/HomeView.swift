//
//  HomeView.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 01/01/2024.
//

import AVKit
import M3UKit
import SwiftData
import SwiftUI
import XMLTV

struct HomeView: View {
	@Environment(\.horizontalSizeClass) private var sizeClass
	@Environment(AppState.self) private var appState

	var body: some View {
		if sizeClass == .compact {
			#if os(iOS)
			MainView()
			#endif
		} else {
			NavigationSplitView {
				SidebarView()
					.navigationDestination(for: TVProgram.self) { program in
						EPGProgramDetailView(for: program)
					}
			} detail: {
				DetailView()
					.onChange(of: appState.selectedPlaylist?.id) {
						print("changed: \(appState.selectedPlaylist?.name ?? "nil")")
					}
					#if os(iOS)
					.toolbarBackground(.visible, for: .navigationBar)
					#endif
			}
		}
	}
}
