//
//  View.swift
//  SpotifyMock
//
//  Created by Uri on 3/8/24.
//

import SwiftUI

extension View {
    
    func themeColors(isSelected: Bool) -> some View {
        self
            .foregroundStyle(isSelected ? .spotifyBlack : .spotifyWhite)
            .background(isSelected ? .spotifyGreen : .spotifyDarkGray)
    }
}
