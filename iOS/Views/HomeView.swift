//
//  HomeView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 01/01/2024.
//

import SwiftUI
import AVKit
import M3UKit
import SwiftData

struct HomeView: View {
	var body: some View {
		NavigationSplitView {
			PlaylistsListView()
		} detail: {
			DetailView()
				.onChange(of: ViewModel.shared.selectedPlaylist?.id) {
					print("changed: \(ViewModel.shared.selectedPlaylist?.name ?? "nil")")
				}
				#if os(iOS)
				.toolbarBackground(.visible, for: .navigationBar)
				#endif
		}
	}
}
