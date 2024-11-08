//
//  AppState.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 12/02/2024.
//

import M3UKit
import Observation
import SwiftData
import SwiftUI

@Observable
class AppState {
	var isAddingPlaylist: Bool = false
	var openedSingleStream: Bool = false

	var selectedPlaylist: Playlist? = nil
	var selectedMedia: Media? = nil
	var selectedGroup: String = "All"
	
	var isLoadingEPG: Bool = true
	var epgModelDidFail: Bool = false
}
