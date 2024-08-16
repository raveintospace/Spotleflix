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
    
    @State private var currentUser: User? = nil
    @State private var productRows: [ProductRow] = []
    @State private var heroProduct: Product? = nil
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.netflixBlack.ignoresSafeArea()
            
            ScrollView(.vertical) {
                VStack(spacing: 8) {
                    Rectangle()
                        .opacity(0)
                        .frame(height: fullHeaderSize.height)
                    
                    if let heroProduct {
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
                    
                    ForEach(0..<20) { _ in
                        Rectangle()
                            .fill(.red)
                            .frame(height: 200)
                    }
                }
            }
            .scrollIndicators(.hidden)
            
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
        }
        .background(.blue)
        .readingFrame { frame in
            fullHeaderSize = frame.size
        }
    }
}


// ZStack's alignment top makes the header / filterBar to be on the top
// header & filters are above ScrollView

// .readingFrame to read the space the VStack occupies on the screen and then create a cell of the same size
