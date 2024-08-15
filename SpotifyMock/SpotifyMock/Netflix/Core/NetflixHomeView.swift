//
//  NetflixHomeView.swift
//  SpotifyMock
//
//  Created by Uri on 15/8/24.
//

import SwiftUI

struct NetflixHomeView: View {
    var body: some View {
        ZStack {
            Color.netflixBlack.ignoresSafeArea()
            
            VStack(spacing: 0) {
                header
                    .padding(.horizontal, 16)
                
                Spacer()
            }
        }
        .foregroundStyle(.netflixWhite)
    }
}

#Preview {
    NetflixHomeView()
}

extension NetflixHomeView {
    
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
}
