//
//  TVView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 01/01/2024.
//

import SwiftUI
import AVKit
import M3UKit
import AZVideoPlayer

struct TVView: View {
    
    @State var showVideoPlayer = false
    
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
                            AsyncImage(url: URL(string: media.attributes.logo ?? "")) { phase in
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
                            AsyncImage(url: URL(string: media.attributes.logo ?? "")) { phase in
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
                    .sheet(isPresented: $showVideoPlayer, content: {
                        VideoPlayer(player: AVPlayer(url: media.url))
                    })
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
                            AsyncImage(url: URL(string: media.attributes.logo ?? "")) { phase in
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
                    .sheet(isPresented: $showVideoPlayer, content: {
                        VideoPlayer(player: AVPlayer(url: media.url))
                    })
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
                            AsyncImage(url: URL(string: media.attributes.logo ?? "")) { phase in
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
                    .sheet(isPresented: $showVideoPlayer, content: {
                        VideoPlayer(player: AVPlayer(url: media.url))
                    })
                }
            }
        }
        .navigationTitle("Movies")
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink {
                        live
                    } label: {
                        Label(
                            title: { Text("Live TV") },
                            icon: { Image(systemName: "tv") }
                        )
                        #if os(tvOS)
                        .padding()
                        #endif
                    }
                    NavigationLink {
                        series
                    } label: {
                        Label(
                            title: { Text("TV Shows") },
                            icon: { Image(systemName: "play.rectangle") }
                        )
                        #if os(tvOS)
                        .padding()
                        #endif
                    }
                    NavigationLink {
                        movies
                    } label: {
                        Label(
                            title: { Text("Movies") },
                            icon: { Image(systemName: "movieclapper") }
                        )
                        #if os(tvOS)
                        .padding()
                        #endif
                    }
                    NavigationLink {
                        unknown
                    } label: {
                        Label(
                            title: { Text("Unknown") },
                            icon: { Image(systemName: "questionmark") }
                        )
                        #if os(tvOS)
                        .padding()
                        #endif
                    }
                } header: {
                    Text("Stream Kind")
                }
                
                #if DEBUG
                Section {
                    Button(action: {print("\($parsedPlaylist)")}, label: {
                        Label(
                            title: { Text("Print Parsed Playlist") },
                            icon: { Image(systemName: "printer") }
                        )
                    })
                } header: {
                    Text("Debug")
                }
                #endif

            }.navigationTitle("Stream Kind")
        }
    }
}
