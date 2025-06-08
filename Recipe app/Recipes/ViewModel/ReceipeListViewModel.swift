//
//  ReceipeListViewModel.swift
//  Recipe app
//
//  Created by rahulKamra-1404 on 6/1/25.
//

import Foundation

enum RecipeSortOption: String, CaseIterable, Identifiable {
    case nameAZ = "Name (A–Z)"
    case nameZA = "Name (Z–A)"
    case cuisine = "Cuisine"

    var id: String { rawValue }
}

@MainActor
class RecipeListViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    @Published var sortOption: RecipeSortOption = .nameAZ

    let service: RecipeServiceProtocol

    init(service: RecipeServiceProtocol = RecipeService()) {
        self.service = service
    }

    var filteredRecipes: [Recipe] {
        if searchText.isEmpty {
            return recipes
        } else {
            return recipes.filter { recipe in
                recipe.name.localizedCaseInsensitiveContains(searchText) ||
                recipe.cuisine.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var sortedRecipes: [Recipe] {
        switch sortOption {
        case .nameAZ:
            return filteredRecipes.sorted { $0.name < $1.name }
        case .nameZA:
            return filteredRecipes.sorted { $0.name > $1.name }
        case .cuisine:
            return filteredRecipes.sorted { $0.cuisine < $1.cuisine }
        }
    }

    func fetchRecipes() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            let fetchedRecipes = try await service.fetchRecipes().recipes
            if fetchedRecipes.isEmpty {
                errorMessage = "No recipes found."
            } else {
                recipes = fetchedRecipes	
            }
        } catch let error as NetworkError {
            errorMessage = "Error: \(error.userMessage)"
        } catch {
            errorMessage = "An unknown error occurred."
        }
    }
}
