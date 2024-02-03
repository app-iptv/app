//
//  PlaylistsViewModel.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 27/01/2024.
//

import SwiftUI
import M3UKit
import SwiftData
import PhotosUI
import Photos
import Foundation
import EmojiPicker

@Model
class SavedPlaylist: Identifiable {
    @Attribute(.unique) var id: UUID
    var name: String
    var playlist: Playlist?
    var emoji: Emoji?
    
    init(id: UUID = UUID(), name: String = "", playlist: Playlist? = nil, emoji: Emoji? = nil) {
        self.id = id
        self.name = name
        self.playlist = playlist
        self.emoji = emoji
    }
}

