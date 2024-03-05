//
//  PlaylistCell.swift
//  IPTV-tvOS
//
//  Created by Pedro Cordeiro on 22/02/2024.
//

import SwiftUI

struct PlaylistCell: View {
	
	var playlist: SavedPlaylist
	
	let letters = (65...90).map { Character(UnicodeScalar($0)!) }
	
	var body: some View {
		VStack {
			Text(String((playlist.name.first ?? letters.randomElement()) ?? "N")) // Show the first letter, default to "N" if nil
				.font(.largeTitle)
				.padding()
			Text(playlist.name) // Show the full name
				.font(.title2)
		}
		.frame(width: 300, height: 300)
	}
}
