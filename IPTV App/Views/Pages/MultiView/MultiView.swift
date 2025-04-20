//
//  MultiView.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 06/02/2025.
//

import SwiftUI
import AVKit

struct MultiView: View {
	@Environment(\.horizontalSizeClass) var sizeClass
	
	@State var medias: [Media] = []
	
	var body: some View {
		VStack {
			Button {
				
			} label: {
				Label("Add Stream", systemImage: "plus.circle")
					.labelStyle(.titleAndIcon)
					.padding(10)
					.frame(maxWidth: .infinity)
			}
			.buttonStyle(.bordered)
			.clipShape(.rect(cornerRadius: .infinity))
			.padding()
			.disabled(medias.count > 3)
			
			Divider()
			
			ScrollView {
				ForEach(medias) { media in
					let player = AVPlayer(url: URL(string: media.url)!)
					
					VideoPlayer(player: player)
				}
			}
		}
	}
}

#Preview {
	MultiView()
}
