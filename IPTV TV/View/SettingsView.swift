//
//  SettingsView.swift
//  IPTV TV
//
//  Created by Pedro Cordeiro on 12/03/2024.
//

import SwiftUI

struct SettingsView: View {
	
	@ObservedObject var vm: ViewModel
	
	var body: some View {
		Form {
			Button("New Playlist", systemImage: "plus") { vm.isPresented.toggle() }
		}
	}
}
