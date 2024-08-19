//
//  NetflixDetailView.swift
//  SpotifyMock
//
//  Created by Uri on 18/8/24.
//

import SwiftUI
import SwiftfulRouting

struct NetflixDetailView: View {
    
    @Environment(\.router) var router
    
    var product: Product = .mock
    
    @State private var progress: Double = 0.2
    @State private var isInMyList: Bool = false
    @State private var products: [Product] = []
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Color.netflixDarkGray.opacity(0.3).ignoresSafeArea()
            
            VStack(spacing: 0) {
                NetflixDetailHeaderView(
                    imageName: product.firstImage,
                    progress: progress,
                    onAirplayPressed: {
                        
                    },
                    onXMarkPressed: {
                        router.dismissScreen()
                    }
                )
                
                ScrollView(.vertical) {
                    VStack(alignment: .leading, spacing: 16) {
                        detailProductSection                        
                        buttonsHStack
                        moreLikeThisVStack
                    }
                    .padding(8)
                }
                .scrollIndicators(.hidden)
            }
        }
        .task {
            await getData()
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    RouterView { _ in
        NetflixDetailView()
    }
}

extension NetflixDetailView {
    
    private func getData() async {
        guard products.isEmpty else { return }
        
        do {
            products = try await DatabaseHelper().getProducts()
        } catch {
            
        }
    }
    
    private func onProductPressed(product: Product) {
        router.showScreen(.sheet) { _ in
            NetflixDetailView(product: product)
        }
    }
    
    private var detailProductSection: some View {
        NetflixDetailProductView(
            title: product.title,
            isNew: true,
            yearReleased: "2024",
            seasonCount: 6,
            hasClosedCaptions: true,
            TopTenNumber: 3,
            descriptionText: product.description,
            castText: "Cast: Joey Tribbiani, Ross Geller, Rachel Green",
            onPlayPressed: {
                
            },
            onDownloadPressed: {
                
            }
        )
    }
    
    private var buttonsHStack: some View {
        HStack(spacing: 32) {
            MyListButton(isInMyList: isInMyList) {
                isInMyList.toggle()
            }
            
            RateButton { selection in
                // do something with selection passed
            }
            
            ShareButton()
        }
        .padding(.leading, 32)
    }
    
    private var moreLikeThisVStack: some View {
        VStack(alignment: .leading) {
            Text("More like this")
                .font(.headline)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3),
                      alignment: .center,
                      spacing: 8,
                      pinnedViews: [],
                      content: {
                ForEach(products) { product in
                    NetflixMovieCell(
                        imageName: product.firstImage,
                        title: product.title,
                        isRecentlyAdded: product.recentlyAdded,
                        topTenRanking: nil
                    )
                    .onTapGesture {
                        onProductPressed(product: product)
                    }
                }
            })
            
        }
        .foregroundStyle(.netflixWhite)
    }
}
