//
//  RecipeListViewModelTests.swift
//  Recipe app
//
//  Created by r0k06op on 6/6/25.
//

import XCTest
@testable import Recipes

final class RecipeListViewModelTests: XCTestCase {

    @MainActor
    func testFetchRecipes_Success() async {
        let mockService = MockRecipeService()
        mockService.mockRecipes = [
            Recipe(id: "123", name: "Pasta", cuisine: "Italian", photoSmall: "url", photoLarge: "url1", sourceURL: nil, youtubeURL: nil),
            Recipe(id: "123", name: "Paneer", cuisine: "indian", photoSmall: "url", photoLarge: "url1", sourceURL: nil, youtubeURL: nil)
        ]

        let viewModel = RecipeListViewModel(service: mockService)
        await viewModel.fetchRecipes()

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.recipes .count, 2)
    }

    @MainActor
    func testFetchRecipes_EmptyResponse() async {
        let mockService = MockRecipeService()
        mockService.mockRecipes = []

        let viewModel = RecipeListViewModel(service: mockService)
        await viewModel.fetchRecipes()

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual("No recipes found.",viewModel.errorMessage)
        XCTAssertEqual(viewModel.recipes.count, 0)
    }

    @MainActor
    func testFetchRecipes_NetworkError() async {
        let mockService = MockRecipeService()
        mockService.shouldReturnError = true

        let viewModel = RecipeListViewModel(service: mockService)

        await viewModel.fetchRecipes()

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual("Error: No data was received from the server.", viewModel.errorMessage)
        XCTAssertEqual(viewModel.recipes.count, 0)
    }

    @MainActor func testFilteredRecipes_WithSearchText() async {
            let mockService = MockRecipeService()
        let viewModel = RecipeListViewModel(service: mockService)
            viewModel.recipes = [
                Recipe(id: "123", name: "Pizza", cuisine: "Italian", photoSmall: "url", photoLarge: "url1", sourceURL: nil, youtubeURL: nil),
                Recipe(id: "123", name: "Biryani", cuisine: "Indian", photoSmall: "url", photoLarge: "url1", sourceURL: nil, youtubeURL: nil)
            ]
            viewModel.searchText = "bir"

            let filtered = viewModel.filteredRecipes

            XCTAssertEqual(filtered.count, 1)
            XCTAssertEqual(filtered.first?.name, "Biryani")
        }

    @MainActor
    func testSortedRecipes_ByNameAZ() {
            let mockService = MockRecipeService()
            let viewModel = RecipeListViewModel(service: mockService)
            viewModel.recipes = [
                Recipe(id: "123", name: "Banana Bread", cuisine: "American", photoSmall: "url", photoLarge: "url1", sourceURL: nil, youtubeURL: nil),
                Recipe(id: "123", name: "Apple Pie", cuisine: "American", photoSmall: "url", photoLarge: "url1", sourceURL: nil, youtubeURL: nil)
            ]
            viewModel.sortOption = .nameAZ

            let sorted = viewModel.sortedRecipes

            XCTAssertEqual(sorted.map { $0.name }, ["Apple Pie", "Banana Bread"])
        }

    @MainActor
        func testSortedRecipes_ByCuisine() {
            let mockService = MockRecipeService()
            let viewModel = RecipeListViewModel(service: mockService)
            viewModel.recipes = [
                Recipe(id: "123", name: "Taco", cuisine: "Mexican", photoSmall: "url", photoLarge: "url1", sourceURL: nil, youtubeURL: nil),
                Recipe(id: "123", name: "Sushi", cuisine: "Japanese", photoSmall: "url", photoLarge: "url1", sourceURL: nil, youtubeURL: nil)
            ]
            viewModel.sortOption = .cuisine

            let sorted = viewModel.sortedRecipes

            XCTAssertEqual(sorted.map { $0.cuisine }, ["Japanese", "Mexican"])
        }
}

class MockRecipeService: RecipeServiceProtocol {
    var shouldReturnError = false
    var mockRecipes: [Recipe] = []

    func fetchRecipes() async throws -> RecipeList {
        if shouldReturnError {
            throw NetworkError.noData
        }
        return RecipeList(recipes: mockRecipes)
    }
}
