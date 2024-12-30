//
//  MediasToolbar.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 17/11/2024.
//

import SwiftUI

struct MediasToolbar: CustomizableToolbarContent {
	@Environment(AppState.self) private var appState
	@Environment(SceneState.self) private var sceneState
	
	@AppStorage("MEDIA_DISPLAY_MODE") private var mediaDisplayMode: MediaDisplayMode = .list
	
	private let groups: [String]
	
	internal init(groups: [String]) {
		self.groups = groups
	}
	
	var body: some CustomizableToolbarContent {
		if !groups.isEmpty {
			ToolbarItem(id: "groupPicker") {
				Picker("Select Group", selection: Bindable(sceneState).selectedGroup) {
					Label("All", systemImage: "tray.2")
						.labelStyle(.titleAndIcon)
						.tag("All")
					
					Divider()
					
					ForEach(groups, id: \.self) { group in
						Label(group, systemImage: "tray")
							.labelStyle(.titleAndIcon)
							.tag(group)
					}
				}
				.pickerStyle(.menu)
			}
		}
		
//		ToolbarItem(id: "displayModePicker") {
//			Picker("Select Display Mode", selection: $mediaDisplayMode) {
//				ForEach(MediaDisplayMode.allCases, id: \.self) { mode in
//					mode.label
//						.labelStyle(.titleAndIcon)
//						.tag(mode)
//				}
//			}
//		}
		
		#if os(iOS)
		ToolbarItem(id: "edit") {
			EditButton()
		}
		#endif
	}
}

extension MediasToolbar {
	var editPlacement: ToolbarItemPlacement {
		return .automatic
	}
}
