//
//  NetflixMovieCell.swift
//  SpotifyMock
//
//  Created by Uri on 17/8/24.
//

import SwiftUI

struct NetflixMovieCell: View {
    
    var width: CGFloat = 90
    var height: CGFloat = 140
    var imageName: String = Constants.randomImage
    var title: String? = "Movie Title"
    var isRecentlyAdded: Bool = false
    var topTenRanking: Int? = nil
    
    var body: some View {
        HStack(alignment: .bottom, spacing: -8) {
            if let topTenRanking {
                Text("\(topTenRanking)")
                    .font(.system(size: 100, weight: .medium, design: .serif))
                    .offset(y: 20)  // push down text baseline
            }
            
            ZStack(alignment: .bottom) {
                ImageLoaderView(urlString: imageName)
                
                VStack(spacing: 0) {
                    if let title, let firstWord = title.components(separatedBy: " ").first {
                        Text(firstWord)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .lineLimit(1)
                    }
                    
                    Text("Recently Added")
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .padding(.bottom,2)
                        .frame(maxWidth: .infinity)
                        .background(.netflixRed)
                        .clipShape(.rect(cornerRadius: 2))
                        .offset(y: 2)
                        .lineLimit(1)
                        .font(.caption2)
                        .fontWeight(.bold)
                        .minimumScaleFactor(0.1)
                        .padding(.horizontal, 8)
                        .opacity(isRecentlyAdded ? 1 : 0)
                }
                .padding(.top, 6)   // so LinearGradient starts higher in y
                .background(
                    LinearGradient(
                        colors: [
                            .netflixBlack.opacity(0),
                            .netflixBlack.opacity(0.3),
                            .netflixBlack.opacity(0.3),
                            .netflixBlack.opacity(0.4)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
            .clipShape(.rect(cornerRadius: 4))
            .frame(width: width, height: height)
        }
        .foregroundStyle(.netflixWhite)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        ScrollView {
            VStack {
                NetflixMovieCell(isRecentlyAdded: true)
                NetflixMovieCell()
                NetflixMovieCell(isRecentlyAdded: true, topTenRanking: 10)
                NetflixMovieCell(topTenRanking: 2)
                NetflixMovieCell(isRecentlyAdded: true, topTenRanking: 10)
                NetflixMovieCell(topTenRanking: 2)
            }
        }
    }
}

// having a fixed size makes the component more performant
// spacing -8 so numbers are "behind" the image
