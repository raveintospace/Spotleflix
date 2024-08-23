//
//  ShareButton.swift
//  SpotifyMock
//
//  Created by Uri on 19/8/24.
//

import SwiftUI

struct ShareButton: View {
    
    var url: String = "https://www.apple.com/"
    
    @ViewBuilder
    var body: some View {
        if let url = URL(string: url) {
            ShareLink(item: url) {
                VStack(spacing: 8) {
                    Image(systemName: "paperplane")
                        .font(.title)
                        .foregroundStyle(.netflixWhite)
                    
                    Text("Share")
                        .font(.caption)
                        .foregroundStyle(.netflixLightGray)
                }
                .padding(8)
                .background(.black.opacity(0.001))
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        ShareButton()
    }
}

// @Viewbuilder just in case
