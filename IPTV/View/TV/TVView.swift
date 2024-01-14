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
    
    enum SidebarItems: String, CaseIterable {
        case live, series, movies, unknown
        
        var name: String {
            switch self {
            case .live: return "Live TV"
            case .series: return "TV Shows"
            case .movies: return "Movies"
            case .unknown: return "Unknown"
            }
        }
        
        var iconName: String {
            switch self {
            case .live: return "tv"
            case .series: return "play.rectangle"
            case .movies: return "movieclapper"
            case .unknown: return "questionmark"
            }
        }
    }
    
    @State var showingPopover = false
    
    @Binding var parsedPlaylist: Playlist?
    
    @Binding var searchText: String
    
    var body: some View {
        NavigationStack {
            List(SidebarItems.allCases, id: \.self) { item in
                NavigationLink(value: item.self) {
                    Label(
                        title: { Text(item.name) },
                        icon: { Image(systemName: item.iconName) }
                    )
                }
                .navigationDestination(for: SidebarItems.self) { item in
                    switch item {
                    case .live:
                        TVFilteredView(parsedPlaylist: $parsedPlaylist, searchText: $searchText).live
                            .searchable(text: $searchText)
                    case .movies:
                        TVFilteredView(parsedPlaylist: $parsedPlaylist, searchText: $searchText).movies
                            .searchable(text: $searchText)
                    case .series:
                        TVFilteredView(parsedPlaylist: $parsedPlaylist, searchText: $searchText).series
                            .searchable(text: $searchText)
                    case .unknown:
                        TVFilteredView(parsedPlaylist: $parsedPlaylist, searchText: $searchText).unknown
                            .searchable(text: $searchText)
                    }
                }
            }
            .listStyle(.inset)
            .navigationTitle("Stream Kind")
            #if targetEnvironment(macCatalyst)
            HStack {
                NavigationLink {
                    SettingsView(parsedPlaylist: $parsedPlaylist)
                } label: {
                    Image(systemName: "gear")
                }
                .buttonStyle(.borderless)
                .padding()
                Spacer()
            }
            #endif
        }
    }
}

/*
struct MediaItemView: View {
    
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
    
    let mediaURL: URL
    let mediaLogo: String
    let mediaName: String
    let mediaGroupTitle: String
    let mediaChannelNumber: String
    
    var body: some View {
        NavigationLink {
            AZVideoPlayer(player: AVPlayer(url: mediaURL),
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
                AsyncImage(url: URL(string: mediaLogo)) { phase in
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
                Text(mediaName)
                    .font(.headline)
                Spacer()
                Text(mediaGroupTitle)
                Text(mediaChannelNumber)
            }
        }
        .buttonStyle(.plain)
    }
}
*/
