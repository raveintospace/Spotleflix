//
//  NetflixDetailView.swift
//  SpotifyMock
//
//  Created by Uri on 18/8/24.
//

import SwiftUI

struct NetflixDetailView: View {
    
    var product: Product = .mock
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Color.netflixDarkGray.opacity(0.3).ignoresSafeArea()
            
            VStack(spacing: 0) {
                
            }
        }
    }
}

#Preview {
    NetflixDetailView()
}
