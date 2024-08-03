//
//  SpotifyCategoryCell.swift
//  SpotifyMock
//
//  Created by Uri on 3/8/24.
//

import SwiftUI

struct SpotifyCategoryCell: View {
    
    var title: String = "Music"
    var isSelected: Bool = false
    
    var body: some View {
        Text(title)
            .font(.callout)
            .padding(.vertical, 8)
            .padding(.horizontal, 10)
            .foregroundStyle(isSelected ? .spotifyBlack : .spotifyWhite)
            .background(isSelected ? .spotifyGreen : .spotifyDarkGray)
            .clipShape(.rect(cornerRadius: 16))
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        VStack(spacing: 40) {
            SpotifyCategoryCell(title: "Title goes here")
            SpotifyCategoryCell(title: "Title goes here", isSelected: true)
            SpotifyCategoryCell(isSelected: true)
        }
    }
}
