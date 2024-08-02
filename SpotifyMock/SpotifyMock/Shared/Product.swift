//
//  Product.swift
//  SpotifyMock
//
//  Created by Uri on 2/8/24.
//

import Foundation

struct ProductArray: Codable {
    let products: [Product]
    let total, skip, limit: Int
}

    // MARK: - Product
struct Product: Codable, Identifiable {
    let id: Int
    let title, description: String
    let price, discountPercentage, rating: Double
    let stock: Int
    let tags: [String]
    let brand: String?
    let sku: String
    let weight: Int
    let minimumOrderQuantity: Int
    let images: [String]
    let thumbnail: String
}
