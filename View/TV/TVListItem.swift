//
//  TVListItem.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 16/01/2024.
//

import SwiftUI
import AVKit
import M3UKit
import AZVideoPlayer

struct TVListItem: View {
    
    @State var mediaURL: URL
    @State var mediaLogo: String?
    @State var mediaName: String
    @State var mediaGroupTitle: String?
    @State var mediaChannelNumber: String?
    
    var player: AVPlayer?
    
    @State var willBeginFullScreenPresentation: Bool = false
    
    func willBeginFullScreen(_ playerViewController: AVPlayerViewController,
                             _ coordinator: UIViewControllerTransitionCoordinator) {
        willBeginFullScreenPresentation = true
    }
    
    func willEndFullScreen(_ playerViewController: AVPlayerViewController,
                           _ coordinator: UIViewControllerTransitionCoordinator) {
        // This is a static helper method provided by AZVideoPlayer to keep the video playing if it was playing when full screen presentation ended
        AZVideoPlayer.continuePlayingIfPlaying(player, coordinator)
    }
    
    var playerView: some View {
        AZVideoPlayer(player: AVPlayer(url: mediaURL),
                      willBeginFullScreenPresentationWithAnimationCoordinator: willBeginFullScreen,
                      willEndFullScreenPresentationWithAnimationCoordinator: willEndFullScreen)
        .aspectRatio(16/9, contentMode: .fit)
        // Adding .shadow(radius: 0) is necessary if your player will be in a List on iOS 16.
        .shadow(radius: 0)
        .onDisappear {
            // onDisappear is called when full screen presentation begins, but the view is not actually disappearing in this case so we don't want to reset the player
            guard !willBeginFullScreenPresentation else {
                willBeginFullScreenPresentation = false
                return
            }
            player?.pause()
        }
    }
    
    var body: some View {
        NavigationLink {
            playerView
        } label: {
            HStack {
                AsyncImage(url: URL(string: mediaLogo!)) { phase in
                    switch phase {
                    case .empty:
                        Image(systemName: "photo")
                            .frame(width: 60, height: 60)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(5)
                            .frame(maxWidth: 60, maxHeight: 60)
                    case .failure:
                        Image(systemName: "photo")
                            .frame(width: 60, height: 60)
                    @unknown default:
                        Image(systemName: "photo")
                            .frame(width: 60, height: 60)
                    }
                }
                .frame(width: 60, height: 60)
                Text(mediaName)
                    .font(.headline)
                Spacer()
                Text(mediaGroupTitle ?? "")
                Text(mediaChannelNumber ?? "")
            }
        }
        .buttonStyle(.plain)
    }
}
