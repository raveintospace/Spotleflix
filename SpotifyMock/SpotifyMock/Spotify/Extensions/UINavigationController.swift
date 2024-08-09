//
//  UINavigationController.swift
//  SpotifyMock
//
//  Created by Uri on 9/8/24.
//

import SwiftUI

// Allows swipe left to go back to previous view
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
