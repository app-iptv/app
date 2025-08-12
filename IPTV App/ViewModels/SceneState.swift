//
//  SceneState.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 26/12/2024.
//

import Foundation

@Observable
final class SceneState {
	var selectedMedia: Media? = nil
	var selectedGroup: String = "All"
	var selectedTab: MediaTab = .favourites
}
