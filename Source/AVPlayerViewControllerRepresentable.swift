//
//  AVPlayerViewControllerRepresentable.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 04/02/2024.
//

import Foundation
import AVKit
import SwiftUI

// MARK: AVPlayerViewControllerRepresentable
#if os(macOS)
struct PlayerView: NSViewRepresentable {
    var videoURL: URL

    func updateNSView(_ nsView: AVPlayerView, context: Context) {
        // Here you can update the player view if needed, based on your app's state
    }
    func makeNSView(context: Context) -> AVPlayerView {
        // Initialize the AVPlayer with the video URL
        let player = AVPlayer(url: videoURL)
        // Create the AVPlayerView
        let playerView = AVPlayerView()
        playerView.player = player
        playerView.showsFullScreenToggleButton = true
        playerView.allowsPictureInPicturePlayback = true
        playerView.player?.allowsExternalPlayback = true
        playerView.controlsStyle = .floating
        return playerView
    }
}
#else
struct PlayerView: UIViewControllerRepresentable { // i have no fucking idea what im doing

    var videoURL: URL

    private var player: AVPlayer {
        return AVPlayer(url: videoURL)
    }

    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
        playerController.player = player
        
        playerController.player?.play()
    }
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        return AVPlayerViewController()
    }
}
#endif

