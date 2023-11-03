//
//  Main.swift
//  ApiSession
//
//  Created by @DavidSanSan110 on 3/11/23.
//

import SwiftUI

class AppState : ObservableObject {
    @Published var view: Int = 0
}

@main
struct ApiSessionApp: App {

    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            if (appState.view == 0) {
                ITunesView(view: $appState.view)
            } else if (appState.view == 1) {
                NasaView(view: $appState.view)
            }
        }
    }
}
