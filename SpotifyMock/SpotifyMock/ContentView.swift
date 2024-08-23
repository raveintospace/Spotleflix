//
//  ContentView.swift
//  SpotifyMock
//
//  Created by Uri on 2/8/24.
//

import SwiftUI
import SwiftfulUI
import SwiftfulRouting

struct ContentView: View {
    
    @Environment(\.router) var router
    
    var body: some View {
        List {
            Button("Open Bumble") {
                router.showScreen(.fullScreenCover) { _ in
                    BumbleHomeView()
                }
            }
            Button("Open Netflix") {
                router.showScreen(.fullScreenCover) { _ in
                    NetflixHomeView()
                }
            }
            Button("Open Spotify") {
                router.showScreen(.fullScreenCover) { _ in
                    SpotifyHomeView()
                }
            }
        }
    }
}

#Preview {
    RouterView { _  in
        ContentView()
    }
}
