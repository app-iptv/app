//
//  TVViewController.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 31/12/2023.
//

import Foundation
import AVKit
import SwiftUI

class IPTVViewModel: ObservableObject {
    @Published var mediaList: [MediaItem] = []
    @Published var appSettings: AppSettings
    
    init(appSettings: AppSettings) {
        self.appSettings = appSettings
        // Initialize mediaList based on appSettings if needed
    }
}

class IPTVViewController: UIViewController, ObservableObject, Identifiable {
    
    @IBOutlet private weak var listTableView: UITableView!
    private var mediaList: [MediaItem] = []
    @Published var appSettings: AppSettings
    
    init(appSettings: AppSettings) {
        self.appSettings = appSettings
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: appSettings.m3uFileLink) {
            do {
                let fileContents = try String(contentsOf: url, encoding: .ascii)
                mediaList = ParseHelper().parseM3U(contentsOfFile: fileContents)
                listTableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell().reuseIdentifier!)
                listTableView.delegate = self
                listTableView.dataSource = self
            } catch {
                print(error)
            }
        }
    }
    
    private func executeUrl(row: Int) {
        if let urlString = mediaList[row].urlString, let url = URL(string: urlString) {
            let player = AVPlayer(url: url)
            let controller = AVPlayerViewController()
            controller.delegate = self
            controller.player = player
            present(controller, animated: true) {
                player.play()
            }
        }
    }
}

extension IPTVViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mediaList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCellIdentifier", for: indexPath)
        cell.textLabel?.text = mediaList[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        executeUrl(row: indexPath.row)
    }
}

extension IPTVViewController: AVPlayerViewControllerDelegate {
    
    func playerViewController(_ playerViewController: AVPlayerViewController, failedToStartPictureInPictureWithError error: Error) {
        print(error)
    }
    
    func playerViewController(_ playerViewController: AVPlayerViewController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        present(playerViewController, animated: false) {
            completionHandler(true)
        }
    }
}
