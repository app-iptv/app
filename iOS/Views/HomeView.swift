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
				.toolbarBackground(.visible, for: .navigationBar)
		}
	}
}
