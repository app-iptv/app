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
    
    @State var showingPopover = false
    
    @Binding var parsedPlaylist: Playlist?
    
    var live: some View {
        List {
            ForEach(parsedPlaylist?.medias ?? [], id: \.self) { media in
                if media.kind == Playlist.Media.Kind.live {
                    NavigationLink {
                        AZVideoPlayer(player: AVPlayer(url: media.url),
                                      willBeginFullScreenPresentationWithAnimationCoordinator: willBeginFullScreen,
                                      willEndFullScreenPresentationWithAnimationCoordinator: willEndFullScreen)
                        .aspectRatio(16/9, contentMode: .fit)
                        // Adding .shadow(radius: 0) is necessary if
                        // your player will be in a List on iOS 16.
                        .shadow(radius: 0)
                        .onDisappear {
                            // onDisappear is called when full screen presentation begins, but the view is
                            // not actually disappearing in this case so we don't want to reset the player
                            guard !willBeginFullScreenPresentation else {
                                willBeginFullScreenPresentation = false
                                return
                            }
                            player?.pause()
                            player?.seek(to: .zero)
                        }
                    } label: {
                        HStack {
                            AsyncImage(url: URL(string: media.attributes.logo!)) { phase in
                                switch phase {
                                case .empty:
                                    Image(systemName: "photo")
                                        .frame(width: 60, height: 60)
                                case .success(let image):
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: 60, maxHeight: 60)
                                case .failure:
                                    Image(systemName: "photo")
                                        .frame(width: 60, height: 60)
                                @unknown default:
                                    EmptyView()
                                        .frame(width: 60, height: 60)
                                }
                            }
                            .frame(width: 60, height: 60)
                            Text(media.name)
                                .font(.headline)
                            Spacer()
                            Text(media.attributes.groupTitle ?? "")
                            Text(media.attributes.channelNumber ?? "")
                        }
                    }
                    .buttonStyle(.plain)
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
                NavigationLink {
                    SettingsView(parsedPlaylist: $parsedPlaylist)
                } label: {
                    Image(systemName: "gear")
                }
            }
        }
        .navigationTitle("Live")
    }
    
    var series: some View {
        List {
            ForEach(parsedPlaylist?.medias ?? [], id: \.self) { media in
                if media.kind == Playlist.Media.Kind.series {
                    NavigationLink {
                        AZVideoPlayer(player: AVPlayer(url: media.url),
                                      willBeginFullScreenPresentationWithAnimationCoordinator: willBeginFullScreen,
                                      willEndFullScreenPresentationWithAnimationCoordinator: willEndFullScreen)
                        .aspectRatio(16/9, contentMode: .fit)
                        // Adding .shadow(radius: 0) is necessary if
                        // your player will be in a List on iOS 16.
                        .shadow(radius: 0)
                        .onDisappear {
                            // onDisappear is called when full screen presentation begins, but the view is
                            // not actually disappearing in this case so we don't want to reset the player
                            guard !willBeginFullScreenPresentation else {
                                willBeginFullScreenPresentation = false
                                return
                            }
                            player?.pause()
                            player?.seek(to: .zero)
                        }
                    } label: {
                        HStack {
                            AsyncImage(url: URL(string: media.attributes.logo!)) { phase in
                                switch phase {
                                case .empty:
                                    Image(systemName: "photo")
                                        .frame(width: 60, height: 60)
                                case .success(let image):
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: 60, maxHeight: 60)
                                case .failure:
                                    Image(systemName: "photo")
                                        .frame(width: 60, height: 60)
                                @unknown default:
                                    EmptyView()
                                        .frame(width: 60, height: 60)
                                }
                            }
                            .frame(width: 60, height: 60)
                            Text(media.name)
                                .font(.headline)
                            Spacer()
                            Text(media.attributes.groupTitle ?? "")
                            Text(media.attributes.channelNumber ?? "")
                        }
                    }
                    .buttonStyle(.plain)
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
                NavigationLink {
                    SettingsView(parsedPlaylist: $parsedPlaylist)
                } label: {
                    Image(systemName: "gear")
                }
            }
        }
        .navigationTitle("Series")
    }
    
    var unknown: some View {
        List {
            ForEach(parsedPlaylist?.medias ?? [], id: \.self) { media in
                if media.kind == Playlist.Media.Kind.unknown {
                    NavigationLink {
                        AZVideoPlayer(player: AVPlayer(url: media.url),
                                      willBeginFullScreenPresentationWithAnimationCoordinator: willBeginFullScreen,
                                      willEndFullScreenPresentationWithAnimationCoordinator: willEndFullScreen)
                        .aspectRatio(16/9, contentMode: .fit)
                        // Adding .shadow(radius: 0) is necessary if
                        // your player will be in a List on iOS 16.
                        .shadow(radius: 0)
                        .onDisappear {
                            // onDisappear is called when full screen presentation begins, but the view is
                            // not actually disappearing in this case so we don't want to reset the player
                            guard !willBeginFullScreenPresentation else {
                                willBeginFullScreenPresentation = false
                                return
                            }
                            player?.pause()
                            player?.seek(to: .zero)
                        }
                    } label: {
                        HStack {
                            AsyncImage(url: URL(string: media.attributes.logo!)) { phase in
                                switch phase {
                                case .empty:
                                    Image(systemName: "photo")
                                        .frame(width: 60, height: 60)
                                case .success(let image):
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: 60, maxHeight: 60)
                                case .failure:
                                    Image(systemName: "photo")
                                        .frame(width: 60, height: 60)
                                @unknown default:
                                    EmptyView()
                                        .frame(width: 60, height: 60)
                                }
                            }
                            .frame(width: 60, height: 60)
                            Text(media.name)
                                .font(.headline)
                            Spacer()
                            Text(media.attributes.groupTitle ?? "")
                            Text(media.attributes.channelNumber ?? "")
                        }
                    }
                    .buttonStyle(.plain)
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
                NavigationLink {
                    SettingsView(parsedPlaylist: $parsedPlaylist)
                } label: {
                    Image(systemName: "gear")
                }
            }
        }
        .navigationTitle("Unknown")
    }
    
    var movies: some View {
        List {
            ForEach(parsedPlaylist?.medias ?? [], id: \.self) { media in
                if media.kind == Playlist.Media.Kind.movie {
                    NavigationLink {
                        AZVideoPlayer(player: AVPlayer(url: media.url),
                                      willBeginFullScreenPresentationWithAnimationCoordinator: willBeginFullScreen,
                                      willEndFullScreenPresentationWithAnimationCoordinator: willEndFullScreen)
                        .aspectRatio(16/9, contentMode: .fit)
                        // Adding .shadow(radius: 0) is necessary if
                        // your player will be in a List on iOS 16.
                        .shadow(radius: 0)
                        .onDisappear {
                            // onDisappear is called when full screen presentation begins, but the view is
                            // not actually disappearing in this case so we don't want to reset the player
                            guard !willBeginFullScreenPresentation else {
                                willBeginFullScreenPresentation = false
                                return
                            }
                            player?.pause()
                            player?.seek(to: .zero)
                        }
                    } label: {
                        HStack {
                            AsyncImage(url: URL(string: media.attributes.logo!)) { phase in
                                switch phase {
                                case .empty:
                                    Image(systemName: "photo")
                                        .frame(width: 60, height: 60)
                                case .success(let image):
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: 60, maxHeight: 60)
                                case .failure:
                                    Image(systemName: "photo")
                                        .frame(width: 60, height: 60)
                                @unknown default:
                                    EmptyView()
                                        .frame(width: 60, height: 60)
                                }
                            }
                            .frame(width: 60, height: 60)
                            Text(media.name)
                                .font(.headline)
                            Spacer()
                            Text(media.attributes.groupTitle ?? "")
                            Text(media.attributes.channelNumber ?? "")
                        }
                    }
                    .buttonStyle(.plain)
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
                NavigationLink {
                    SettingsView(parsedPlaylist: $parsedPlaylist)
                } label: {
                    Image(systemName: "gear")
                }
            }
        }
        .navigationTitle("Movies")
    }
    
    var body: some View {
        EmptyView()
    }
}
