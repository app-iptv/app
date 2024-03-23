//
//  Playlist.Media.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 01/03/2024.
//

import Foundation
import M3UKit

extension Playlist.Media: Identifiable {
	public var id: UUID { UUID() }
}
