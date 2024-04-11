//
//  SettingsView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 24/03/2024.
//

import SwiftUI

struct SettingsView: View {
	
	@AppStorage("IS_FIRST_LAUNCH") var isFirstLaunch: Bool = false
	
	@AppStorage("VIEWING_MODE") var viewingMode: ViewingMode = .regular
	
	@Bindable var vm: ViewModel
	
	@Binding var isRemovingAll: Bool
	
	var body: some View {
		#if targetEnvironment(macCatalyst)
		NavigationStack {
			content
		}
		#else
		content
		#endif
	}
	
	private var content: some View {
		NavigationStack {
			Form {
				Section {
					Toggle("Show Wecome Screen Again", systemImage: "rectangle.inset.filled", isOn: $isFirstLaunch)
					Picker("Viewing Mode", systemImage: "list.triangle", selection: $viewingMode) {
						ForEach(ViewingMode.allCases) { mode in
							mode.label.tag(mode)
						}
					}
					#if !targetEnvironment(macCatalyst)
					NavigationLink {
						ChangeIconView()
					} label: {
						Label("Change App Icon", systemImage: "app.dashed")
					}
					#endif
				}
				
				Section {
					Button("Reset Favorites", systemImage: "trash", role: .destructive) { isRemovingAll.toggle() }.foregroundStyle(.red)
				}
				
				Section {
					NavigationLink { AboutView() } label: { Label("About", systemImage: "info.circle") }
				}
			}
			.navigationTitle("Settings")
		}
	}
}
