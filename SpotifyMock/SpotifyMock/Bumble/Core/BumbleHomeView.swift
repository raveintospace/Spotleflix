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
    
    @State private var currentSwipeOffset: CGFloat = 0
    
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
                                userProfileCell(user: user, index: index)
                                    .zIndex(Double(allUsers.count - index))
                                    .offset(x: offsetValue == nil ? 0 : offsetValue == true ? 900 : -900)
                            }
                        }
                    } else {
                        ProgressView()
                    }
                    
                    overlaySwipingIndicators
                        .zIndex(99999)
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
    
    private func userProfileCell(user: User, index: Int) -> some View {
        BumbleCardView(
            user: user,
            onSendComplimentPressed: nil,
            onSuperlikePressed: nil,
            onXmarkPressed: {
                userDidSelect(index: index, isLike: false)
            },
            onChecmarkPressed: {
                userDidSelect(index: index, isLike: true)
            },
            onHideAndReportPressed: nil
        )
        .withDragGesture(
            .horizontal,
            minimumDistance: 10,    // minimum distance dragged to read as a drag
            resets: true,
            rotationMultiplier: 1.05,
            onChanged: { dragOffset in
                currentSwipeOffset = dragOffset.width
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
    
    private var overlaySwipingIndicators: some View {
        ZStack {
            Circle()
                .fill(.bumbleGray.opacity(0.4))
                .overlay(
                    Image(systemName: "xmark")
                        .font(.title)
                        .fontWeight(.semibold)
                )
                .frame(width: 60, height: 60)
                .scaleEffect(abs(currentSwipeOffset) > 110 ? 1.5 : 1.0)
                .offset(x: min(-currentSwipeOffset, 200)) // moves opposite to swipe gesture
                .offset(x: -100) // starts out of the screen
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Circle()
                .fill(.bumbleGray.opacity(0.4))
                .overlay(
                    Image(systemName: "checkmark")
                        .font(.title)
                        .fontWeight(.semibold)
                )
                .frame(width: 60, height: 60)
                .scaleEffect(abs(currentSwipeOffset) > 110 ? 1.5 : 1.0)
                .offset(x: max(-currentSwipeOffset, -200)) // moves opposite to swipe gesture
                .offset(x: 100) // starts out of the screen
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .animation(.smooth, value: currentSwipeOffset)
    }
}

// AppStorage retains the value and recovers it when reopening the app

// .zIndex(Double(allUsers.count - index)) -> to have currentUser on top of Zstack

// .offset(x: offsetValue == nil ? 0 : offsetValue == true ? 900 : -900) -> if the isLike from userDidSelect is true, moves the card to 900; if it's false moves the card to -900; does nothing if value is nil

// minimumDistance: 10 -> if we don't set a value, the scrollView won't work, because it will be read always as a drag
