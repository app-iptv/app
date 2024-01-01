//
//  SettingsView.swift
//  IPTV
//
//  Created by Pedro Cordeiro on 31/12/2023.
//

import SwiftUI
import M3UKit

struct SettingsView: View {
    
    @State var enteredURL = ""
    @StateObject private var appSettings = AppSettings()
    let viewModel = TVViewModel(appSettings: AppSettings())

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Playlist URL")) {
                    #if DEBUG
                    HStack {
                        TextField("Enter Playlist URL", text: $enteredURL)
                            .disableAutocorrection(true)
                        Spacer()
                        Button("Reload Playlist") {
                            appSettings.IPTVLink = enteredURL
                            viewModel.loadMediaList()
                        }
                    }
                    Button("Print Playlist") {
                        print(appSettings.IPTVLink)
                    }
                    #endif
                }
            }
            .navigationBarTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
