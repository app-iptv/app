//
//  M3UParse.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 31.12.2023.
//

import Foundation

struct MediaItem: Codable {
    var duration: Int?
    var title: String?
    var urlString: String?
}

class ParseHelper {
    func parseM3U(contentsOfFile: String) -> [MediaItem] {
        var mediaItems = [MediaItem]()
        
        contentsOfFile.enumerateLines(invoking: { line, stop in
            
            if line.hasPrefix("#EXTINF:") {
                
                let infoLine = line.replacingOccurrences(of: "#EXTINF:", with: "")
                
                let infos = Array(infoLine.components(separatedBy: ","))
                
                if let durationString = infos.first, let duration = Int(durationString) {
                    let mediaItem = MediaItem(duration: duration, title: infos.last?.trimmingCharacters(in: .whitespaces), urlString: nil)
                    mediaItems.append(mediaItem)
                    
                }
            } else {
                
                if mediaItems.count > 0 {
                    mediaItems[mediaItems.count].urlString = line
                }
            }
        })
        return mediaItems
    }
}
