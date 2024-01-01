//
//  TVView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 31/12/2023.
//

import SwiftUI
import AVKit

struct TVView: View {
    @ObservedObject private var viewModel = TVViewModel(appSettings: AppSettings())
    var body: some View {
        NavigationView {
            List(viewModel.mediaList.indices) { index in
                let mediaItem = viewModel.mediaList[index]
                NavigationLink(destination: VideoPlayerView(urlString: mediaItem.urlString ?? "")) {
                    Text(mediaItem.title ?? "Unknown Title")
                }
            }
            .navigationBarTitle("TV Channels")
        }
        .onAppear {
            viewModel.loadMediaList()
        }
    }
}

struct VideoPlayerView: View {
    var urlString: String

    var body: some View {
        if let url = URL(string: urlString) {
            VideoPlayer(player: AVPlayer(url: url)) {
                Text("Video playback failed.")
            }
            .navigationBarTitle("Video Player", displayMode: .inline)
        } else {
            Text("Invalid URL")
        }
    }
}

class TVViewModel: ObservableObject {
    @Published var mediaList: [MediaItem] = []
    @Published var appSettings: AppSettings
    
    init(appSettings: AppSettings) {
        self.appSettings = appSettings
        // Load media list based on appSettings.m3uFileLink
    }
    
    func loadMediaList() {
        guard let url = URL(string: appSettings.m3uFileLink) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            
            if let data = data, let fileContents = String(data: data, encoding: .ascii) {
                DispatchQueue.main.async {
                    self.mediaList = ParseHelper().parseM3U(contentsOfFile: fileContents)
                }
            }
        }
        task.resume()
    }
}


#Preview {
    TVView()
}
