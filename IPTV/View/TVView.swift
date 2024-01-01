//
//  TVView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 31/12/2023.
//

import SwiftUI
import AVKit

struct TVView: View {
    
    @State var showFullscreen = false
    
    @ObservedObject private var viewModel = TVViewModel(appSettings: AppSettings())
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.mediaList) { media in
                    NavigationLink {
                        VideoPlayerView(urlString: media.urlString ?? "")
                    } label: {
                        Text(media.title ?? "Unknown Title")
                            .font(.headline)
                    }
                }
                NavigationLink {
                    VideoPlayer(player: AVPlayer(url: URL(string: "http://sample.vodobox.net/skate_phantom_flex_4k/skate_phantom_flex_4k.m3u8")!))
                } label: {
                    Text("Test")
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
    
    @State var showFullscreen = false
    
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
        guard let url = URL(string: appSettings.IPTVLink) else {
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
                    self.mediaList = MediaItem.parseM3U(contentsOfFile: fileContents)!
                }
            }
        }
        task.resume()
    }
}


#Preview {
    TVView()
}
