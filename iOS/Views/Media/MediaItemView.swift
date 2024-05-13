//
//  MediaItemView.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 28/04/2024.
//

import SwiftUI
import XMLTV

struct MediaItemView: View {
	let media: Media
	let playlistName: String
	let epgLink: String
	let medias: [Media]
	
	@Binding var xmlTV: XMLTV?
	
	@State var programs: [TVProgram]? = nil
		
	var body: some View {
		NavigationLink {
			MediaDetailView(playlistName: playlistName, media: media, epgLink: epgLink, xmlTV: $xmlTV)
		} label: {
			MediaCellView(media: media, playlistName: playlistName)
		}
		.badge(medias.firstIndex(of: media)!+1)
	}
}
