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
    
    @State var showingPopover = false
    
    @Binding var parsedPlaylist: Playlist?
    
    var live: some View {
        List {
            ForEach(parsedPlaylist?.medias ?? [], id: \.self) { media in
                if media.kind == Playlist.Media.Kind.live {
                    MediaItemView(mediaURL: media.url, mediaLogo: media.attributes.logo, mediaName: media.name, mediaGroupTitle: media.attributes.groupTitle, mediaChannelNumber: media.attributes.channelNumber)
                }
            }
            .onDelete { parsedPlaylist?.medias.remove(atOffsets: $0) }
            .onMove { parsedPlaylist?.medias.move(fromOffsets: $0, toOffset: $1) }
        }
        .toolbarRole(.browser)
        .toolbar {
            ToolbarItem {
                EditButton()
            }
            ToolbarItem {
                Button {
                    showingPopover.toggle()
                } label: {
                    Image(systemName: "slider.horizontal.3")
                }
            }
        }
        .navigationTitle("Live")
    }
    
    var series: some View {
        List {
            ForEach(parsedPlaylist?.medias ?? [], id: \.self) { media in
                if media.kind == Playlist.Media.Kind.series {
                    MediaItemView(mediaURL: media.url, mediaLogo: media.attributes.logo, mediaName: media.name, mediaGroupTitle: media.attributes.groupTitle, mediaChannelNumber: media.attributes.channelNumber)
                }
            }
            .onDelete { parsedPlaylist?.medias.remove(atOffsets: $0) }
            .onMove { parsedPlaylist?.medias.move(fromOffsets: $0, toOffset: $1) }
        }
        .toolbarRole(.browser)
        .toolbar {
            ToolbarItem {
                EditButton()
            }
            ToolbarItem {
                Button {
                    showingPopover.toggle()
                } label: {
                    Image(systemName: "slider.horizontal.3")
                }
            }
        }
        .navigationTitle("Series")
    }
    
    var unknown: some View {
        List {
            ForEach(parsedPlaylist?.medias ?? [], id: \.self) { media in
                if media.kind == Playlist.Media.Kind.unknown {
                    MediaItemView(mediaURL: media.url, mediaLogo: media.attributes.logo, mediaName: media.name, mediaGroupTitle: media.attributes.groupTitle, mediaChannelNumber: media.attributes.channelNumber)
                }
            }
            .onDelete { parsedPlaylist?.medias.remove(atOffsets: $0) }
            .onMove { parsedPlaylist?.medias.move(fromOffsets: $0, toOffset: $1) }
        }
        .toolbarRole(.browser)
        .toolbar {
            ToolbarItem {
                EditButton()
            }
            ToolbarItem {
                Button {
                    showingPopover.toggle()
                } label: {
                    Image(systemName: "slider.horizontal.3")
                }
            }
        }
        .navigationTitle("Unknown")
    }
    
    var movies: some View {
        List {
            ForEach(parsedPlaylist?.medias ?? [], id: \.self) { media in
                if media.kind == Playlist.Media.Kind.movie {
                    MediaItemView(mediaURL: media.url, mediaLogo: media.attributes.logo, mediaName: media.name, mediaGroupTitle: media.attributes.groupTitle, mediaChannelNumber: media.attributes.channelNumber)
                }
            }
            .onDelete { parsedPlaylist?.medias.remove(atOffsets: $0) }
            .onMove { parsedPlaylist?.medias.move(fromOffsets: $0, toOffset: $1) }
        }
        .toolbarRole(.browser)
        .toolbar {
            ToolbarItem {
                EditButton()
            }
            ToolbarItem {
                Button {
                    showingPopover.toggle()
                } label: {
                    Image(systemName: "slider.horizontal.3")
                }
            }
        }
        .navigationTitle("Movies")
    }
    
    var body: some View {
        EmptyView()
    }
}
