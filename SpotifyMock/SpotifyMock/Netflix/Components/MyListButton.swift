//
//  MyListButton.swift
//  SpotifyMock
//
//  Created by Uri on 18/8/24.
//

import SwiftUI

struct MyListButton: View {
    
    var isInMyList: Bool = false
    var onButtonPressed: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Image(systemName: "checkmark")
                    .opacity(isInMyList ? 1 : 0)
                    .rotationEffect(Angle(degrees: isInMyList ? 0 : 180))
                
                Image(systemName: "plus")
                    .opacity(isInMyList ? 0 : 1)
                    .rotationEffect(Angle(degrees: isInMyList ? -180 : 0))
            }
            .font(.title)
            .foregroundStyle(.netflixWhite)
            
            Text("My List")
                .font(.caption)
                .foregroundStyle(.netflixLightGray)
        }
        .padding(8)
        .background(.black.opacity(0.001))
        .animation(.bouncy, value: isInMyList)
        .onTapGesture {
            onButtonPressed?()
        }
    }
}

fileprivate struct MyListButtonPreview: View {
    
    @State private var isInMyList: Bool = false
    
    var body: some View {
        MyListButton(isInMyList: isInMyList) {
            isInMyList.toggle()
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        MyListButtonPreview()
    }
}

// .opacity instead of if else so "My List" frame doesn't move
// -180 so it rotates in the opposite direction Vs 180
