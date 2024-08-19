//
//  NetflixDetailView.swift
//  SpotifyMock
//
//  Created by Uri on 18/8/24.
//

import SwiftUI

struct NetflixDetailView: View {
    
    var product: Product = .mock
    
    @State private var progress: Double = 0.2
    @State private var isInMyList: Bool = false
    
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
                        
                    }
                )
                
                ScrollView(.vertical) {
                    VStack(alignment: .leading, spacing: 16) {
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
                        
                        HStack(spacing: 32) {
                            MyListButton(isInMyList: isInMyList) {
                                isInMyList.toggle()
                            }
                            
                            RateButton { selection in
                                // do something with selection passed
                            }
                            
                            ShareButton()
                        }
                    }
                    .padding(8)
                }
                .scrollIndicators(.hidden)
            }
        }
    }
}

#Preview {
    NetflixDetailView()
}
