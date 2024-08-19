//
//  NetflixHomeView.swift
//  SpotifyMock
//
//  Created by Uri on 15/8/24.
//

import SwiftUI
import SwiftfulUI
import SwiftfulRouting

struct NetflixHomeView: View {
    
    @Environment(\.router) var router
    
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
            
            backgroundGradientLayer
            scrollViewLayer
            fullHeaderWithFilters
        }
        .foregroundStyle(.netflixWhite)
        .task {
            await getData()
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    RouterView { _ in
        NetflixHomeView()
    }
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
                rows.append(ProductRow(title: brand, products: products.shuffled()))
            }
            productRows = rows
        } catch {
            
        }
    }
    
    private func onProductPressed(product: Product) {
        router.showScreen(.sheet) { _ in
            NetflixDetailView(product: product)
        }
    }
    
    private var backgroundGradientLayer: some View {
        ZStack {
            LinearGradient(
                colors: [.netflixDarkGray.opacity(1), .netflixDarkGray.opacity(0)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            LinearGradient(
                colors: [.netflixDarkRed.opacity(0.5), .netflixDarkRed.opacity(0)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        }
        .frame(maxHeight: max(10, (400 + (scrollViewOffset * 0.75))))
        .opacity(scrollViewOffset < -250 ? 0 : 1)
        .animation(.easeInOut, value: scrollViewOffset)
    }
    
    private var scrollViewLayer: some View {
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
                    
                    categoryRows
                }
            },
            onScrollChanged: { offset in
                scrollViewOffset = min(0, offset.y)
            }
        )
    }
    
    private var header: some View {
        HStack(spacing: 0) {
            Text("For You")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title)
                .onTapGesture {
                    router.dismissScreen()
                }
            
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
    
    private var fullHeaderWithFilters: some View {
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
        .padding(.bottom, 8)
        .background(
            ZStack {
                if scrollViewOffset < -70 {
                    Rectangle()
                        .fill(.clear)
                        .background(.ultraThinMaterial)
                        .brightness(-0.2)
                        .ignoresSafeArea()
                }
            }
        )
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
                onProductPressed(product: heroProduct)
            },
            onPlayPressed: {
                onProductPressed(product: heroProduct)
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
                                .onTapGesture {
                                    onProductPressed(product: product)
                                }
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

// .readingFrame to read the space the VStack occupies on the screen and then create a Rectangle of the same height, so HeroCell is below fullHeaderWithFilters
// if fullHeaderSize == .zero -> set fullHeaderSize only if is .zero

// set the padding on the HStack so the scroll view "eats the edges" of screen

// https://youtu.be/OL6CSivnrqk?si=GnjDFqQjQL1TOD1B - Netflix L4
// ScrollViewWithOnScrollChanged -> SwiftfulUI
// onScrollChanged reads vertical scroll (Y) to hide filters & update header's opacity
// scrollViewOffset = min(0, offset.y) -> only update it when 0 or less (-), animations are smooth

// .transition(.move(edge: .top).combined(with: .opacity)) -> move to top and make it transparent

// .frame(maxHeight: 400 + (scrollViewOffset * 0.75)) Gradient scrolls with scrollView, but slower
// frame max(10 -> never gets below size 10


/*
 MVVM
 Move this to viewmodel
 @State private var filters = FilterModel.mockArray
 @State private var selectedFilter: FilterModel? = nil
 
 // tracks size of VStack with header + filters
 @State private var fullHeaderSize: CGSize = .zero
 
 // tracks vertical scroll of ScrollViewWith...
 @State private var scrollViewOffset: CGFloat = 0
 
 @State private var currentUser: User? = nil
 @State private var productRows: [ProductRow] = []
 @State private var heroProduct: Product? = nil
 
 move funcs to viewmodel
 */

