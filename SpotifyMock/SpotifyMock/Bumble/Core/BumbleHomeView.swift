//
//  BumbleHomeView.swift
//  SpotifyMock
//
//  Created by Uri on 10/8/24.
//

import SwiftUI

struct BumbleHomeView: View {
    var body: some View {
        ZStack {
            Color.bumbleWhite.ignoresSafeArea()
            
            VStack(spacing: 8) {
                HStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Image(systemName: "line.horizontal.3")
                            .padding(8)
                            .background(.black.opacity(0.001))
                            .onTapGesture {
                                
                            }
                        
                        Image(systemName: "arrow.uturn.left")
                            .padding(8)
                            .background(.black.opacity(0.001))
                            .onTapGesture {
                                
                            }
                    }
                    .background(.red)
                    
                    Text("bumble")
                        .font(.title)
                        .foregroundStyle(.bumbleYellow)
                        .background(.blue)
                    
                    Image(systemName: "slider.horizontal.3")
                        .padding(8)
                        .background(.black.opacity(0.001))
                        .onTapGesture {
                            
                        }
                        .background(.red)
                }
                .font(.title2)
                .fontWeight(.medium)
                .foregroundStyle(.bumbleBlack)
            }
        }
    }
}

#Preview {
    BumbleHomeView()
}
