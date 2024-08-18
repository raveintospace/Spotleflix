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
                    
                }
                .scrollIndicators(.hidden)
            }
        }
    }
}

#Preview {
    NetflixDetailView()
}
