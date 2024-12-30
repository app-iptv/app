//
//  MediaDetailViewModel.swift
//  IPTV App
//
//  Created by Pedro Cordeiro on 15/12/2024.
//

import Foundation
import SwiftUI
import XMLTV

@Observable
@MainActor
final class MediaDetailViewModel {
	var isUnsupported: Bool = false
	var currentProgram: TVProgram? = nil
	var hasFinishedLoading: Bool = false
	var programs: [TVProgram]? = nil
	
	func fetchPrograms(for media: Media, with fetchingModel: EPGFetchingController, and appState: AppState) async {
		guard let xmlTV = fetchingModel.xmlTV else { return abortFetching(with: appState) }
		guard let channelID = media.attributes["tvg-id"] else { return abortFetching(with: appState) }
		
		let channels = xmlTV.getChannels()
		
		guard !channels.isEmpty else { return abortFetching(with: appState) }
		guard let channel = channels.first(where: { $0.id == channelID }) else { return abortFetching(with: appState) }
		
		let programs = xmlTV.getPrograms(channel: channel)
		
		guard !programs.isEmpty else { return abortFetching(with: appState) }
		
		self.programs = programs
		
		abortFetching(with: appState)
	}
	
	func abortFetching(with appState: AppState) {
		appState.isLoadingEPG = false
	}
	
	var noProgramsForChannelView: some View {
		VStack {
			Spacer()
			ContentUnavailableView(
				"TV Guide is empty",
				systemImage: "tv.slash",
				description: Text(
					"The EPG link provided does not include any programs for this channel."
				))
			Spacer()
		}
	}

	func epgListView(_ programs: [TVProgram]) -> some View {
		ScrollView {
			ScrollViewReader { reader in
				VStack(alignment: .leading, spacing: 0) {
					ForEach(programs, id: \.self) { program in
						NavigationLink(value: program) {
							EPGProgramView(for: program)
						}
						.buttonStyle(.borderless)
						.foregroundStyle(.primary)
						.id(program.isCurrent())
					}
					.onAppear {
						withAnimation {
							reader.scrollTo(true, anchor: .center)
						}
					}
				}
			}
			#if !os(macOS)
				.safeAreaPadding(.horizontal, 5)
			#endif
		}
	}
}
