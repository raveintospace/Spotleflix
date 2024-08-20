//
//  BumbleChatsView.swift
//  SpotifyMock
//  https://youtu.be/mpt6QnbE3o8?si=HaIoH8hLgmKbBGCF
//  Created by Uri on 13/8/24.
//

import SwiftUI
import SwiftfulRouting

struct BumbleChatsView: View {
    
    @Environment(\.router) var router
    
    @Bindable var viewModel: BumbleViewModel
    //@State private var allUsers: [User] = []
    
    var body: some View {
        ZStack {
            Color.bumbleWhite.ignoresSafeArea()
            
            VStack(spacing: 0) {
                header
                    .padding(16)
                
                matchQueueSection
                    .padding(.vertical, 16)
                
                recentChatsSection
            }
        }
        .task {
            await viewModel.getData()
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    RouterView { _ in
        BumbleChatsView(viewModel: BumbleViewModel())
    }
}

extension BumbleChatsView {
    
//    private func getData() async {
//        guard allUsers.isEmpty else { return }
//        
//        do {
//            allUsers = try await DatabaseHelper().getUsers()
//        } catch {
//            
//        }
//    }
    
    private var header: some View {
        HStack(spacing: 0) {
            Image(systemName: "line.horizontal.3")
                .onTapGesture {
                    router.dismissScreen()
                }
            Spacer()
            Image(systemName: "magnifyingglass")
        }
        .font(.title)
        .fontWeight(.medium)
        .foregroundStyle(.bumbleBlack)
    }
    
    private var matchQueueSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Group {
                Text("Match queue ")
                    .foregroundStyle(.bumbleBlack)
                +
                Text("(\(viewModel.allUsers.count))")
                    .foregroundStyle(.bumbleGray)
            }
            .padding(.horizontal, 16)
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: 16) {
                    ForEach(viewModel.allUsers) { user in
                        BumbleProfileImageCell(
                            imageName: user.image,
                            percentageRemaining: Double.random(in: 0...1),
                            hasNewMessage: Bool.random()
                        )
                    }
                }
                .padding(.horizontal, 16) // profile pics "disappear" nicely
            }
            .scrollIndicators(.hidden)
            .frame(height: 100) // to set scrollview below "match queue" title
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var recentChatsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 0) {
                Group {
                    Text("Chats")
                        .foregroundStyle(.bumbleBlack)
                    +
                    Text("(Recent)")
                        .foregroundStyle(.bumbleGray)
                }
                Spacer(minLength: 0)
                Image(systemName: "line.horizontal.3.decrease")
                    .font(.title2)
                    .foregroundStyle(.bumbleBlack)
            }
            .padding(.horizontal, 16)
            
            ScrollView(.vertical) {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.allUsers) { user in
                        BumbleChatPreviewCell(
                            imageName: user.images.randomElement()!,
                            percentageRemaining: Double.random(in: 0...1),
                            hasNewMessage: Bool.random(),
                            userName: user.firstName,
                            message: user.aboutMe,
                            isYourMove: Bool.random()
                        )
                    }
                }
                .padding(16)
            }
            .scrollIndicators(.hidden)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
