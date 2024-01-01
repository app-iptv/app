//
//  M3UParse.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 31.12.2023.
//

import Foundation

struct MediaItem: Identifiable {
    
    var id = UUID()
    var duration: Int?
    var title: String?
    var urlString: String?

    static func parseM3U(contentsOfFile: String) -> [MediaItem]? {
        var mediaItems = [MediaItem]()
        contentsOfFile.enumerateLines(invoking: { line, stop in
            if line.hasPrefix("#EXTINF:") {
                let infoLine = line.replacingOccurrences(of: "#EXTINF:", with: "")
                let infos = Array(infoLine.split(separator: ","))

                let durationString = String(infos.first ?? "")
                if let duration = Int(durationString) {

                    let mediaItem = MediaItem(
                        duration: duration,
                        title: String(infos.last ?? ""),
                        urlString: nil
                    )
                    mediaItems.append(mediaItem)
                }
            } else {
                if mediaItems.count > 0 {
                    var item = mediaItems.last
                    item?.urlString = line
                }
            }
        })
        return mediaItems
    }

    static func getDefault() {

        if
            let path = Bundle.main.path(forResource: "playlist", ofType: "m3u"),
            let contentsOfFile = try? String(contentsOfFile: path, encoding: String.Encoding(rawValue: NSUTF8StringEncoding)) {
            dump(MediaItem.parseM3U(contentsOfFile: contentsOfFile))
        }

    }
}
