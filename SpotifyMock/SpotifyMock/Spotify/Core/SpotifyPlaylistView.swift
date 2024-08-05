//
//  SpotifyPlaylistView.swift
//  SpotifyMock
//
//  Created by Uri on 5/8/24.
//

import SwiftUI

struct SpotifyPlaylistView: View {
    
    var product: Product = .mock
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView(.vertical) {
                LazyVStack(spacing: 12) {
                    PlaylistHeaderCell(
                        height: 250,
                        title: product.title,
                        subtitle: product._brand,
                        imageName: product.thumbnail
                    )
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    SpotifyPlaylistView()
}
