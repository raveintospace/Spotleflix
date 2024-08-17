//
//  NetflixHomeView.swift
//  SpotifyMock
//
//  Created by Uri on 15/8/24.
//

import SwiftUI
import SwiftfulUI

struct NetflixHomeView: View {
    
    @State private var filters = FilterModel.mockArray
    @State private var selectedFilter: FilterModel? = nil
    
    // tracks size of VStack with header + filters
    @State private var fullHeaderSize: CGSize = .zero
    
    // tracks vertical scroll of ScrollViewWith...
    @State private var scrollViewOffset: CGFloat = 0
    
    @State private var currentUser: User? = nil
    @State private var productRows: [ProductRow] = []
    @State private var heroProduct: Product? = nil
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.netflixBlack.ignoresSafeArea()
            
            ScrollViewWithOnScrollChanged(
                .vertical,
                showsIndicators: false,
                content: {
                    VStack(spacing: 8) {
                        Rectangle()
                            .opacity(0)
                            .frame(height: fullHeaderSize.height)
                        
                        if let heroProduct {
                            heroCell(heroProduct: heroProduct)
                        }
                        
                        Text("\(scrollViewOffset)")
                            .foregroundStyle(.red)
                        
                        categoryRows
                    }
                },
                onScrollChanged: { offset in
                    scrollViewOffset = offset.y
                }
            )
            
            fullHeader
        }
        .foregroundStyle(.netflixWhite)
        .task {
            await getData()
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    NetflixHomeView()
}

extension NetflixHomeView {
    
    private func getData() async {
        guard productRows.isEmpty else { return }
        
        do {
            currentUser = try await DatabaseHelper().getUsers().first
            let products = try await DatabaseHelper().getProducts()
            heroProduct = products.first
            
            // mock to populate productRows
            var rows: [ProductRow] = []
            let allBrands = Set(products.map({ $0._brand }))  // set = unique values
            for brand in allBrands {
                // commented to have more products, otherwise only products of brand
                // let products = self.products.filter({ $0.brand == brand })
                rows.append(ProductRow(title: brand, products: products))
            }
            productRows = rows
        } catch {
            
        }
    }
    
    private var header: some View {
        HStack(spacing: 0) {
            Text("For You")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title)
            
            HStack(spacing: 16) {
                Image(systemName: "tv.badge.wifi")
                    .onTapGesture {
                        
                    }
                
                Image(systemName: "magnifyingglass")
                    .onTapGesture {
                        
                    }
            }
            .font(.title2)
        }
    }
    
    private var fullHeader: some View {
        VStack(spacing: 0) {
            header
                .padding(.horizontal, 16)
            
            if scrollViewOffset > -20 {
                NetflixFilterBarView(
                    filters: filters,
                    onXMarkPressed: {
                        selectedFilter = nil
                    },
                    onFilterPressed: { newFilter in
                        selectedFilter = newFilter
                    },
                    selectedFilter: selectedFilter
                )
                .padding(.top, 16)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .background(.blue)
        .animation(.smooth, value: scrollViewOffset)
        .readingFrame { frame in
            if fullHeaderSize == .zero {
                fullHeaderSize = frame.size
            }
        }
    }
    
    private func heroCell(heroProduct: Product) -> some View {
        NetflixHeroCell(
            imageName: heroProduct.firstImage,
            isNetflixFilm: true,
            title: heroProduct.title,
            categories: [heroProduct.category.capitalized, heroProduct._brand],
            onBackgroundPressed: {
                
            },
            onPlayPressed: {
                
            },
            onMyListPressed: {
                
            }
        )
        .padding(24)
    }
    
    private var categoryRows: some View {
        LazyVStack(spacing: 16) {
            ForEach(Array(productRows.enumerated()), id: \.offset) { (rowIndex, row) in
                VStack(alignment: .leading, spacing: 6) {
                    Text(row.title)
                        .font(.headline)
                        .padding(.horizontal, 16)
                    
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(Array(row.products.enumerated()), id: \.offset) { (index, product) in
                                NetflixMovieCell(
                                    imageName: product.firstImage,
                                    title: product.title,
                                    isRecentlyAdded: product.recentlyAdded,
                                    topTenRanking: rowIndex == 1 ? (index + 1) : nil
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    .scrollIndicators(.hidden)
                }
            }
        }
    }
}


// ZStack's alignment top makes the header / filterBar to be on the top
// header & filters are above ScrollView

// .readingFrame to read the space the VStack occupies on the screen and then create a cell of the same size
// if fullHeaderSize == .zero -> set fullHeaderSize only if is .zero


// set the padding on the HStack so the scroll view "eats the edges" of screen

// https://youtu.be/OL6CSivnrqk?si=GnjDFqQjQL1TOD1B
// ScrollViewWithOnScrollChanged -> SwiftfulUI
// onScrollChanged reads vertical scroll (Y) to hide filters & update header's opacity

// .transition(.move(edge: .top).combined(with: .opacity)) -> move top top and make it transparent
