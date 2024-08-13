//
//  BumbleChatsView.swift
//  SpotifyMock
//
//  Created by Uri on 13/8/24.
//

import SwiftUI

struct BumbleChatsView: View {
    
    @State private var allUsers: [User] = []
    
    var body: some View {
        ZStack {
            Color.bumbleWhite.ignoresSafeArea()
            
            VStack(spacing: 0) {
                header
                    .padding(16)
                
                VStack(alignment: .leading, spacing: 8) {
                    Group {
                        Text("Match Queue ")
                        +
                        Text("(\(allUsers.count))")
                            .foregroundStyle(.bumbleGray)
                    }
                    .padding(.horizontal, 16)
                    
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 16) {
                            ForEach(allUsers) { user in
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
                    .frame(height: 100) // to set scrollview below match queue
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
            }
            
            
        }
        .task {
            await getData()
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    BumbleChatsView()
}

extension BumbleChatsView {
    
    private func getData() async {
        guard allUsers.isEmpty else { return }
        
        do {
            allUsers = try await DatabaseHelper().getUsers()
        } catch {
            
        }
    }
    
    private var header: some View {
        HStack(spacing: 0) {
            Image(systemName: "line.horizontal.3")
            Spacer()
            Image(systemName: "magnifyingglass")
        }
        .font(.title)
        .fontWeight(.medium)
    }
}
