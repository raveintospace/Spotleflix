//
//  ImageTitleRowCell.swift
//  SpotifyMock
//
//  Created by Uri on 4/8/24.
//

import SwiftUI

struct ImageTitleRowCell: View {
    
    var imageName: String = Constants.randomImage
    var title: String = "Some Item name"
    
    // specific size because cells are inside a ScrollView
    // this way image size is not calculated when appearing on view
    var imageSize: CGFloat = 100
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ImageLoaderView(urlString: imageName)
                .frame(width: imageSize, height: imageSize)
            
            Text(title)
                .font(.callout)
                .foregroundStyle(.spotifyLightGray)
                .lineLimit(2)
                .padding(4)
        }
        .frame(width: imageSize) // same width as image, restricts text
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        ImageTitleRowCell()
    }
}
