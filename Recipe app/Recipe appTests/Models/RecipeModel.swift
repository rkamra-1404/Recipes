//
//  RecipeModel.swift
//  Recipe app
//
//  Created by r0k06op on 6/6/25.
//

import XCTest
@testable import Recipes

final class RecipeModelTests: XCTestCase {

    func testRecipeDecoding() throws {
        let json = """
        {
            "uuid": "123",
            "name": "Pasta",
            "cuisine": "Italian",
            "photo_url_small": "https://example.com/small.jpg",
            "photo_url_large": "https://example.com/large.jpg",
            "source_url": "https://example.com/source",
            "youtube_url": "https://youtube.com/example"
        }
        """.data(using: .utf8)!

        let recipe = try JSONDecoder().decode(Recipe.self, from: json)

        XCTAssertEqual(recipe.id, "123")
        XCTAssertEqual(recipe.name, "Pasta")
        XCTAssertEqual(recipe.cuisine, "Italian")
        XCTAssertEqual(recipe.photoSmall, "https://example.com/small.jpg")
        XCTAssertEqual(recipe.photoLarge, "https://example.com/large.jpg")
        XCTAssertEqual(recipe.sourceURL, "https://example.com/source")
        XCTAssertEqual(recipe.youtubeURL, "https://youtube.com/example")
    }

    func testRecipeListDecoding() throws {
        let json = """
        {
            "recipes": [
                {
                    "uuid": "123",
                    "name": "Pasta",
                    "cuisine": "Italian",
                    "photo_url_small": "https://example.com/small.jpg",
                    "photo_url_large": "https://example.com/large.jpg",
                    "source_url": "https://example.com/source",
                    "youtube_url": "https://youtube.com/example"
                },
                {
                    "uuid": "456",
                    "name": "Sushi",
                    "cuisine": "Japanese",
                    "photo_url_small": "https://example.com/small2.jpg",
                    "photo_url_large": "https://example.com/large2.jpg",
                    "source_url": null,
                    "youtube_url": null
                }
            ]
        }
        """.data(using: .utf8)!

        let recipeList = try JSONDecoder().decode(RecipeList.self, from: json)

        XCTAssertEqual(recipeList.recipes.count, 2)
        XCTAssertEqual(recipeList.recipes[0].name, "Pasta")
        XCTAssertEqual(recipeList.recipes[1].name, "Sushi")
        XCTAssertNil(recipeList.recipes[1].sourceURL)
    }
}
