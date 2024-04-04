//
//  MediasListView.swift
//  IPTV TV
//
//  Created by Pedro Cordeiro on 14/03/2024.
//

import SwiftUI
import M3UKit
import SDWebImageSwiftUI
import SwiftUI
import AVKit

struct MediasListView: View {
	
	let medias: [Media]
	
	let playlistName: String
	
	var groupedMediaDictionary: [String: [Media]] = [:]
	
	@State var mediaSearchTex: String = ""
	
	mutating func groupMedias() {
		for media in medias {
			if var group = groupedMediaDictionary[media.attributes.groupTitle ?? "Undefined"] {
				group.append(media)
				groupedMediaDictionary[media.attributes.groupTitle ?? "Undefined"] = group
			} else {
				groupedMediaDictionary[media.attributes.groupTitle ?? "Undefined"] = [media]
			}
		}
	}
	
	init(medias: [Media], playlistName: String) {
		self.medias = medias
		self.playlistName = playlistName
		
		groupMedias()
	}
	
	var body: some View {
		ScrollView {
			LazyVStack {
				ForEach(groupedMediaDictionary.sorted(by: { $0.key < $1.key }), id: \.key) { groupTitle, medias in
					MediaGroupView(groupTitle: groupTitle, medias: medias)
				}
			}
		}
	}
}

#Preview {
	MediaItemView(media:
		Media(duration: 0,
			attributes:
			Attributes(
				logo: "https://upload.wikimedia.org/wikipedia/fr/3/31/SIC_logo_2018.png",
				groupTitle: "Portugal"
			),
			kind: .live,
			name: "SIC",
			url: URL(string: "https://google.com")!
		)
	)
}
