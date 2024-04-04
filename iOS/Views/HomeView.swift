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
	
	@Bindable var vm: ViewModel
	
	init(_ vm: ViewModel) { self.vm = vm }
	
	var body: some View {
		NavigationSplitView {
			PlaylistsListView(vm)
		} detail: {
			DetailView(vm)
		}
	}
}
