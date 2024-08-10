//
//  BumbleCardView.swift
//  SpotifyMock
//
//  Created by Uri on 10/8/24.
//

import SwiftUI

struct BumbleCardView: View {
    
    var user: User = .mock
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                headerCell
                    .frame(height: 700)
            }
        }
        .scrollIndicators(.hidden)
        .clipShape(.rect(cornerRadius: 32))
    }
}

#Preview {
    BumbleCardView()
        .padding(.vertical, 40)
        .padding(.horizontal, 16)
}

extension BumbleCardView {
    
    private var headerCell: some View {
        ZStack(alignment: .bottomLeading) {
            ImageLoaderView(urlString: user.image)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("\(user.firstName), \(user.age)")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
                HStack(spacing: 4) {
                    Image(systemName: "suitcase")
                    Text(user.work)
                }
                HStack(spacing: 4) {
                    Image(systemName: "graduationcap")
                    Text(user.education)
                }
                
                BumbleHeartView()
                    .onTapGesture {
                        
                    }
            }
            .padding(24)
            .font(.callout)
            .fontWeight(.medium)
            .foregroundStyle(.bumbleWhite)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                LinearGradient(
                    colors: [
                        .black.opacity(0),
                        .black.opacity(0.6),
                        .black.opacity(0.6)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
    }
}

// black.opacity(0.6) twice to extend the opacity
