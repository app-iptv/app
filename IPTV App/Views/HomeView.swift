//
//  HomeView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 01/01/2024.
//

import AVKit
import M3UKit
import SwiftData
import SwiftUI
import XMLTV

struct HomeView: View {
	@Environment(ViewModel.self) private var vm

	var body: some View {
		NavigationSplitView {
			SidebarView()
				.navigationDestination(for: TVProgram.self) { program in
					EPGProgramDetailView(for: program)
				}
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
