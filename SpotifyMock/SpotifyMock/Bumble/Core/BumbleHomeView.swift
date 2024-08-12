//
//  BumbleHomeView.swift
//  SpotifyMock
//  https://youtu.be/rAZItPC1GIY?si=px3p7-0FpBoXIix3
//  Created by Uri on 10/8/24.
//

import SwiftUI
import SwiftfulUI

struct BumbleHomeView: View {
    
    @State private var filters: [String] = ["Everyone", "Trending"]
    @AppStorage("bumble_home_filter") private var selectedFilter = "Everyone"
    
    @State private var allUsers: [User] = []
    
    // to track previous, current and next user
    @State private var selectedIndex: Int = 0
    
    // to track if user swipes left (false) or right (true)
    @State private var cardOffsets: [Int: Bool] = [:]  // [UserId: Bool]
    
    var body: some View {
        ZStack {
            Color.bumbleWhite.ignoresSafeArea()
            
            VStack(spacing: 12) {
                header
                BumbleFilterView(options: filters, selection: $selectedFilter)
                    .background(Divider(), alignment: .bottom)
                // BumbleCardView()
                
                ZStack {
                    if !allUsers.isEmpty {
                        ForEach(Array(allUsers.enumerated()), id: \.offset) { (index, user) in
                            
                            let isPrevious = (selectedIndex - 1) == index
                            let isCurrent = selectedIndex == index
                            let isNext = (selectedIndex + 1) == index
                            
                            if isPrevious || isCurrent || isNext {
                                let offsetValue = cardOffsets[user.id]
                                userProfileCell(index: index)
                                    .zIndex(Double(allUsers.count - index))
                                    .offset(x: offsetValue == nil ? 0 : offsetValue == true ? 900 : -900)
                            }
                        }
                    } else {
                        ProgressView()
                    }
                }
                .frame(maxHeight: .infinity) // keeps header & filters always on top, even when we haven't loaded the images
                .animation(.smooth, value: cardOffsets)
            }
            .padding(8)
        }
        .task {
            await getData()
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    BumbleHomeView()
}

extension BumbleHomeView {
    
    private var header: some View {
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
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("bumble")
                .font(.title)
                .foregroundStyle(.bumbleYellow)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Image(systemName: "slider.horizontal.3")
                .padding(8)
                .background(.black.opacity(0.001))
                .onTapGesture {
                    
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .font(.title2)
        .fontWeight(.medium)
        .foregroundStyle(.bumbleBlack)
    }
    
    private func getData() async {
        guard allUsers.isEmpty else { return }
        
        do {
            allUsers = try await DatabaseHelper().getUsers()
        } catch {
            
        }
    }
    
    private func userDidSelect(index: Int, isLike: Bool) {
        let currentUser = allUsers[index]
        cardOffsets[currentUser.id] = isLike // set true or false for UserId
        
        // increment index to move to next card
        selectedIndex += 1
        
    }
    
    private func userProfileCell(index: Int) -> some View {
        Rectangle()
            .fill(index == 0 ? .red : .blue)
            .overlay(
                Text("\(index)")
            )
            .withDragGesture(
                .horizontal,
                resets: true,
                rotationMultiplier: 1.05,
                onChanged: { dragOffset in
                    //
                },
                onEnded: { dragOffset in
                    if dragOffset.width < -80 {
                        userDidSelect(index: index, isLike: false)
                    } else if dragOffset.width > 80 {
                        userDidSelect(index: index, isLike: true)
                    }
                }
            )
    }
}

// AppStorage retains the value and recovers it when reopening the app

// .zIndex(Double(allUsers.count - index)) -> to have currentUser on top of Zstack

// .offset(x: offsetValue == nil ? 0 : offsetValue == true ? 900 : -900) -> sets the value of cardOffsets to true (900) or false (-900) with the swipe, value is nil if no swipe
