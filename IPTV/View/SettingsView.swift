//
//  SettingsView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 31/12/2023.
//

import SwiftUI
import M3UKit

class AppSettings: ObservableObject {
    @State var m3uFileLink = ""
}

struct SettingsView: View {
    
    @State var enteredURL = ""
    @StateObject private var appSettings = AppSettings()
    let viewModel = TVViewModel(appSettings: AppSettings())

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Playlist URL")) {
                    HStack {
                        TextField("Enter Playlist URL", text: $enteredURL)
                            .disableAutocorrection(true)
                        Spacer()
                        Button("Reload Playlist") {
                            appSettings.m3uFileLink = enteredURL
                            viewModel.loadMediaList()
                        }
                    }
                }
            }
            .navigationBarTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
