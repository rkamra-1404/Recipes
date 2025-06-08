//
//  Untitled.swift
//  Recipe app
//
//  Created by rahulKamra-1404 on 6/1/25.
//

import Foundation

struct RecipeList: Codable {
    let recipes: [Recipe]
}

struct Recipe: Identifiable, Codable {
    let id: String
    let name: String
    let cuisine: String
    let photoSmall: String
    let photoLarge: String
    let sourceURL: String?
    let youtubeURL: String?

    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name
        case cuisine
        case photoSmall = "photo_url_small"
        case photoLarge = "photo_url_large"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
}
