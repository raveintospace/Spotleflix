//
//  SpotifyNewReleaseCell.swift
//  SpotifyMock
//
//  Created by Uri on 3/8/24.
//

import SwiftUI

struct SpotifyNewReleaseCell: View {
    
    var imageName: String = Constants.randomImage
    var headline: String? = "New release from"
    var subheadline: String? = "Some Artist"
    var title: String? = "Some Playlist"
    var subtitle: String? = "Single - title"
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                ImageLoaderView(urlString: imageName)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 2) {
                    if let headline {
                        Text(headline)
                            .foregroundStyle(.spotifyLightGray)
                            .font(.callout)
                    }
                    
                    if let subheadline {
                        Text(subheadline)
                            .foregroundStyle(.spotifyWhite)
                            .font(.title2)
                            .fontWeight(.medium)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        SpotifyNewReleaseCell()
    }
}
