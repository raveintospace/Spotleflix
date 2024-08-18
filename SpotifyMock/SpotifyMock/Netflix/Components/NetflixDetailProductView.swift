//
//  NetflixDetailProductView.swift
//  SpotifyMock
//  https://youtu.be/05nHvBhhfow?si=1xZx5CflZ7ol2qkJ
//  Created by Uri on 18/8/24.
//

import SwiftUI
import SwiftfulUI

struct NetflixDetailProductView: View {
    
    var title: String = "Movie Title"
    var isNew: Bool = true
    var yearReleased: String? = "2024"
    var seasonCount: Int? = 2
    var hasClosedCaptions: Bool = true
    var TopTenNumber: Int? = 6
    var descriptionText: String? = "This is the description for the title that is selected and it should go multiple lines lorem ipsum blablabla"
    var castText: String? = "Cast: Joey Tribbiani, Ross Geller, Rachel Green"
    var onPlayPressed: (() -> Void)? = nil
    var onDownloadPressed: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 8) {
                if isNew {
                    Text("New")
                        .foregroundStyle(.green)
                }
                
                if let yearReleased {
                    Text(yearReleased)
                }
                
                if let seasonCount {
                    Text("\(seasonCount) Seasons")
                }
                
                if hasClosedCaptions {
                    Image(systemName: "captions.bubble")
                }
            }
            .foregroundStyle(.netflixLightGray)
            
            if let TopTenNumber {
                HStack(spacing: 8) {
                    topTenIcon
                    
                    Text("#\(TopTenNumber) in TV Shows today")
                        .font(.headline)
                }
            }
            
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "play.fill")
                    Text("Play")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .foregroundStyle(.netflixDarkGray)
                .background(.netflixWhite)
                .clipShape(.rect(cornerRadius: 4))
                .asButton {
                    onPlayPressed?()
                }
                HStack {
                    Image(systemName: "arrow.down.to.line.alt")
                    Text("Download")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .foregroundStyle(.netflixWhite)
                .background(.netflixDarkGray)
                .clipShape(.rect(cornerRadius: 4))
                .asButton {
                    onDownloadPressed?()
                }
            }
            .font(.callout)
            .fontWeight(.medium)
            
            Group {
                if let descriptionText {
                    Text(descriptionText)
                }
                
                if let castText {
                    Text(castText)
                        .foregroundStyle(.netflixLightGray)
                }
            }
            .font(.callout)
            .frame(maxWidth: .infinity, alignment: .leading)
            .multilineTextAlignment(.leading)
        }
        .foregroundStyle(.netflixWhite)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        VStack(spacing: 40) {
            NetflixDetailProductView()
            NetflixDetailProductView(
                isNew: false,
                yearReleased: nil,
                seasonCount: nil,
                hasClosedCaptions: false,
                TopTenNumber: nil,
                descriptionText: nil,
                castText: nil
            )
        }
    }
}

extension NetflixDetailProductView {
    
    private var topTenIcon: some View {
        Rectangle()
            .fill(.netflixRed)
            .frame(width: 28, height: 28)
            .overlay(
                VStack(spacing: -4) {
                    Text("TOP")
                        .font(.system(size: 8))
                    Text("10")
                        .font(.system(size: 16))
                }
                    .fontWeight(.bold)
                    .offset(y: 1)
            )
    }
}

// Group lets us access and add modifiers to its components at the same time
