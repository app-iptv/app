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
final class AppState {
	var isAddingPlaylist: Bool = false
	var openedSingleStream: Bool = false

	var isLoadingEPG: Bool = true
	var epgModelDidFail: Bool = false
}
