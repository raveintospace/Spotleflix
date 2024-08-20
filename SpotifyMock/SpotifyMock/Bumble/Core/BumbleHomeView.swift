//
//  BumbleHomeView.swift
//  SpotifyMock
//  https://youtu.be/rAZItPC1GIY?si=px3p7-0FpBoXIix3
//  Created by Uri on 10/8/24.
//

import SwiftUI
import SwiftfulUI
import SwiftfulRouting

struct BumbleHomeView: View {
    
    @Environment(\.router) var router
    
    @State private var viewModel = BumbleViewModel()
    
    @AppStorage("bumble_home_filter") private var selectedFilter = "Everyone"
    
//    @State private var filters: [String] = ["Everyone", "Trending"]
//    
//    @State private var allUsers: [User] = []
//    
//    // to track previous, current and next user
//    @State private var selectedIndex: Int = 0
//    
//    // to track if user swipes left (false) or right (true)
//    @State private var cardOffsets: [Int: Bool] = [:]  // [UserId: Bool]
//    
//    @State private var currentSwipeOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            Color.bumbleWhite.ignoresSafeArea()
            
            VStack(spacing: 12) {
                header
                BumbleFilterView(options: viewModel.filters, selection: $selectedFilter)
                    .background(Divider(), alignment: .bottom)
                
                ZStack {
                    if !viewModel.allUsers.isEmpty {
                        ForEach(Array(viewModel.allUsers.enumerated()), id: \.offset) { (index, user) in
                            
                            let isPrevious = (viewModel.selectedIndex - 1) == index
                            let isCurrent = viewModel.selectedIndex == index
                            let isNext = (viewModel.selectedIndex + 1) == index
                            
                            if isPrevious || isCurrent || isNext {
                                let offsetValue = viewModel.cardOffsets[user.id]
                                userProfileCell(user: user, index: index)
                                    .zIndex(Double(viewModel.allUsers.count - index))
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
                .padding(4)
                .animation(.smooth, value: viewModel.cardOffsets)
            }
            .padding(8)
        }
        .task {
            await viewModel.getData()
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    RouterView { _ in
        BumbleHomeView()
    }
}

extension BumbleHomeView {
    
//    private func getData() async {
//        guard viewModel.allUsers.isEmpty else { return }
//        
//        do {
//            viewModel.allUsers = try await DatabaseHelper().getUsers()
//        } catch {
//            
//        }
//    }
    
    private var header: some View {
        HStack(spacing: 0) {
            HStack(spacing: 0) {
                Image(systemName: "line.horizontal.3")
                    .padding(8)
                    .background(.black.opacity(0.001))
                    .onTapGesture {
                        router.dismissScreen()
                    }
                
                Image(systemName: "arrow.uturn.left")
                    .padding(8)
                    .background(.black.opacity(0.001))
                    .onTapGesture {
                        router.dismissScreen()
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
                    router.showScreen(.push) { _ in
                        BumbleChatsView(viewModel: viewModel)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .font(.title2)
        .fontWeight(.medium)
        .foregroundStyle(.bumbleBlack)
    }
    
    private func userDidSelect(index: Int, isLike: Bool) {
        let currentUser = viewModel.allUsers[index]
        viewModel.cardOffsets[currentUser.id] = isLike // set true or false for UserId
        
        // increment index to move to next card
        viewModel.selectedIndex += 1
        
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
                viewModel.currentSwipeOffset = dragOffset.width
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
                .scaleEffect(abs(viewModel.currentSwipeOffset) > 110 ? 1.5 : 1.0)
                .offset(x: min(-viewModel.currentSwipeOffset, 200)) // moves opposite to swipe gesture
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
                .scaleEffect(abs(viewModel.currentSwipeOffset) > 110 ? 1.5 : 1.0)
                .offset(x: max(-viewModel.currentSwipeOffset, -200)) // moves opposite to swipe gesture
                .offset(x: 100) // starts out of the screen
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .animation(.smooth, value: viewModel.currentSwipeOffset)
    }
}

// AppStorage retains the value and recovers it when reopening the app

// .zIndex(Double(allUsers.count - index)) -> to have currentUser on top of Zstack

// .offset(x: offsetValue == nil ? 0 : offsetValue == true ? 900 : -900) -> if the isLike from userDidSelect is true, moves the card to 900; if it's false moves the card to -900; does nothing if value is nil

// minimumDistance: 10 -> if we don't set a value, the scrollView won't work, because it will be always read as a drag
