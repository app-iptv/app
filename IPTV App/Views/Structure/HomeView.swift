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
			} detail: {
				DetailView()
			}
		}
	}
}
