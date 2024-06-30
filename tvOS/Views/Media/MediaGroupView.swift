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
			GridRow(alignment: .center) {
				LazyVStack(alignment: .leading, spacing: 10) {
					Text(LocalizedStringKey(group))
						.font(.subheadline)
					ScrollView([.horizontal]) {
						HStack {
							ForEach(groupedMedias) { media in
								TVMediaItemView(media: media, isTV: isTV, size: .regular)
							}
						}
					}
					.safeAreaPadding(.bottom, 40)
				}
			}
		}
	}
}

private extension MediaGroupView {
	var groupedMedias: [Media] {
		medias?.filter { ($0.attributes["group-title"] ?? "Untitled") == group } ?? []
	}
}
