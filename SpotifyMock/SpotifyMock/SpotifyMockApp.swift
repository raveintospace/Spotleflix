//
//  SpotifyMockApp.swift
//  SpotifyMock
//
//  Created by Uri on 2/8/24.
//

import SwiftUI
import SwiftfulRouting

@main
struct SpotifyMockApp: App {
    var body: some Scene {
        WindowGroup {
            RouterView { _ in
                ContentView()
            }
        }
    }
}
