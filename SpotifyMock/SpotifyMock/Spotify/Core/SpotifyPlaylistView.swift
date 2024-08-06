//
//  SpotifyPlaylistView.swift
//  SpotifyMock
//
//  Created by Uri on 5/8/24.
//

import SwiftUI

struct SpotifyPlaylistView: View {
    
    var product: Product = .mock
    var user: User = .mock
    
    @State private var products: [Product] = []
    
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
                    
                    PlaylistDescriptionCell(
                        descriptionText: product.description,
                        userName: user.firstName,
                        subheadline: product.category,
                        onAddToPlaylistPressed: nil,
                        onDownloadPressed: nil,
                        onSharedPressed: nil,
                        onEllipsisPressed: nil,
                        onShufflePressed: nil,
                        onPlayPressed: nil
                    )
                    .padding(.horizontal, 16)
                    
                    ForEach(products) { product in
                        SongRowCell(
                            imageSize: 50,
                            imageName: product.firstImage,
                            title: product.title,
                            subtitle: product._brand) {
                                
                            } onEllipsisPressed: {
                                
                            }
                    }
                    .padding(.horizontal, 16)
                }
            }
            .scrollIndicators(.hidden)
        }
        .task {
            await getData()
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    SpotifyPlaylistView()
}

extension SpotifyPlaylistView {
    
    // another api call to mimic real app logic
    // we don't pass the products from home view, we make another api call
    private func getData() async {
        do {
            products = try await DatabaseHelper().getProducts()
        } catch  {
            
        }
    }
}
