//
//  TVFilteredView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 09/01/2024.
//

import Foundation
import SwiftUI
import AVKit
import AZVideoPlayer
import M3UKit

struct TVFilteredView: View {
    
    var player: AVPlayer?
    
    @State var willBeginFullScreenPresentation: Bool = false
    
    func willBeginFullScreen(_ playerViewController: AVPlayerViewController,
                             _ coordinator: UIViewControllerTransitionCoordinator) {
        willBeginFullScreenPresentation = true
    }
    
    func willEndFullScreen(_ playerViewController: AVPlayerViewController,
                           _ coordinator: UIViewControllerTransitionCoordinator) {
        // This is a static helper method provided by AZVideoPlayer to keep
        // the video playing if it was playing when full screen presentation ended
        AZVideoPlayer.continuePlayingIfPlaying(player, coordinator)
    }
    
    @Binding var parsedPlaylist: Playlist?
    
    @Binding var searchText: String
    
    var searchResults: [Playlist.Media] {
        if searchText.isEmpty {
            return parsedPlaylist?.medias ?? []
        } else {
            return parsedPlaylist?.medias.filter { $0.name.contains(searchText) } ?? []
        }
    }
    
    var live: some View {
        List {
            ForEach(searchResults, id: \.self) { media in
                if media.kind == Playlist.Media.Kind.live {
                    TVListItem(mediaURL: media.url, mediaLogo: media.attributes.logo, mediaName: media.name, mediaGroupTitle: media.attributes.groupTitle, mediaChannelNumber: media.attributes.channelNumber)
                        .contextMenu {
                            ShareLink(item: media.url)
                        } preview: {
                            TVListItem(mediaURL: media.url, mediaLogo: media.attributes.logo, mediaName: media.name, mediaGroupTitle: media.attributes.groupTitle, mediaChannelNumber: media.attributes.channelNumber)
                        }
                }
            }
            .onDelete { parsedPlaylist?.medias.remove(atOffsets: $0) }
            .onMove { parsedPlaylist?.medias.move(fromOffsets: $0, toOffset: $1) }
        }
        .listStyle(.plain)
        .navigationTitle("Live")
    }
    
    var series: some View {
        List {
            ForEach(searchResults, id: \.self) { media in
                if media.kind == Playlist.Media.Kind.series {
                    TVListItem(mediaURL: media.url, mediaLogo: media.attributes.logo, mediaName: media.name, mediaGroupTitle: media.attributes.groupTitle, mediaChannelNumber: media.attributes.channelNumber)
                        .contextMenu {
                            ShareLink(item: media.url)
                        } preview: {
                            TVListItem(mediaURL: media.url, mediaLogo: media.attributes.logo, mediaName: media.name, mediaGroupTitle: media.attributes.groupTitle, mediaChannelNumber: media.attributes.channelNumber)
                        }
                }
            }
            .onDelete { parsedPlaylist?.medias.remove(atOffsets: $0) }
            .onMove { parsedPlaylist?.medias.move(fromOffsets: $0, toOffset: $1) }
        }
        .listStyle(.plain)
        .navigationTitle("Series")
    }
    
    var unknown: some View {
        List {
            ForEach(searchResults, id: \.self) { media in
                if media.kind == Playlist.Media.Kind.unknown {
                    TVListItem(mediaURL: media.url, mediaLogo: media.attributes.logo, mediaName: media.name, mediaGroupTitle: media.attributes.groupTitle, mediaChannelNumber: media.attributes.channelNumber)
                        .contextMenu {
                            ShareLink(item: media.url)
                        } preview: {
                            TVListItem(mediaURL: media.url, mediaLogo: media.attributes.logo, mediaName: media.name, mediaGroupTitle: media.attributes.groupTitle, mediaChannelNumber: media.attributes.channelNumber)
                        }
                }
            }
            .onDelete { parsedPlaylist?.medias.remove(atOffsets: $0) }
            .onMove { parsedPlaylist?.medias.move(fromOffsets: $0, toOffset: $1) }
        }
        .listStyle(.plain)
        .navigationTitle("Unknown")
    }
    
    var movies: some View {
        List {
            ForEach(searchResults, id: \.self) { media in
                if media.kind == Playlist.Media.Kind.movie {
                    TVListItem(mediaURL: media.url, mediaLogo: media.attributes.logo, mediaName: media.name, mediaGroupTitle: media.attributes.groupTitle, mediaChannelNumber: media.attributes.channelNumber)
                        .contextMenu {
                            ShareLink(item: media.url)
                        } preview: {
                            TVListItem(mediaURL: media.url, mediaLogo: media.attributes.logo, mediaName: media.name, mediaGroupTitle: media.attributes.groupTitle, mediaChannelNumber: media.attributes.channelNumber)
                        }
                }
            }
            .onDelete { parsedPlaylist?.medias.remove(atOffsets: $0) }
            .onMove { parsedPlaylist?.medias.move(fromOffsets: $0, toOffset: $1) }
        }
        .listStyle(.plain)
        .navigationTitle("Movies")
        
    }
    
    var body: some View {
        EmptyView()
    }
}

