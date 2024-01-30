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
    
    func willBeginFullScreen(_ playerViewController: AVPlayerViewController, _ coordinator: UIViewControllerTransitionCoordinator) { willBeginFullScreenPresentation = true }
    
    func willEndFullScreen(_ playerViewController: AVPlayerViewController, _ coordinator: UIViewControllerTransitionCoordinator) { AZVideoPlayer.continuePlayingIfPlaying(player, coordinator) }
    
    var body: some View {
        AZVideoPlayer(player: AVPlayer(url: mediaURL), willBeginFullScreenPresentationWithAnimationCoordinator: willBeginFullScreen, willEndFullScreenPresentationWithAnimationCoordinator: willEndFullScreen)
        .aspectRatio(16/9, contentMode: .fit)
        .shadow(radius: 0)
        .onDisappear {
            guard !willBeginFullScreenPresentation else { willBeginFullScreenPresentation = false; return }
            player?.pause()
        }
    }
    
    var buttonCover: some View {
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
}
