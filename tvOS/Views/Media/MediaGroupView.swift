//
//  MediaGroupView.swift
//  IPTV TV App
//
//  Created by Pedro Cordeiro on 19/05/2024.
//

import SwiftUI

struct MediaGroupView: View {
	private var medias: [Media]?
	private var group: String
	private var isTV: Bool

	internal init(medias: [Media]? = nil, group: String, isTV: Bool) {
		self.medias = medias
		self.group = group
		self.isTV = isTV
	}

	var body: some View {
		if !groupedMedias.isEmpty {
			ScrollView(.horizontal) {
				HStack(spacing: 40) {
					ForEach(groupedMedias) { media in
						TVMediaItemView(media: media, isTV: isTV)
					}
				}
			}
			.scrollClipDisabled()
		}
	}
}

extension MediaGroupView {
	private var groupedMedias: [Media] {
		medias?.filter { ($0.attributes["group-title"] ?? "Untitled") == group }
			?? []
	}
}
