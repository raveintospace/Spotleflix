//
//  BumbleViewModel.swift
//  SpotifyMock
//
//  Created by Uri on 20/8/24.
//

import SwiftUI

@Observable
final class BumbleViewModel {
    
    var filters: [String] = ["Everyone", "Trending"]
    
    var allUsers: [User] = []
    
    // to track previous, current and next user
    var selectedIndex: Int = 0
    
    // to track if user swipes left (false) or right (true)
    var cardOffsets: [Int: Bool] = [:]  // [UserId: Bool]
    
    var currentSwipeOffset: CGFloat = 0
    
    func getData() async {
        guard allUsers.isEmpty else { return }
        
        do {
            allUsers = try await DatabaseHelper().getUsers()
        } catch {
            
        }
    }
    
}
    
