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
	@Environment(ViewModel.self) private var vm
	
	var body: some View {
		NavigationSplitView {
			PlaylistsListView()
		} detail: {
			DetailView()
				.onChange(of: vm.selectedPlaylist?.id) {
					print("changed: \(vm.selectedPlaylist?.name ?? "nil")")
				}
				#if os(iOS)
				.toolbarBackground(.visible, for: .navigationBar)
				#endif
		}
	}
}
