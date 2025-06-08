//
//  RecipeService.swift
//  Recipe app
//
//  Created by rahulKamra-1404 on 6/1/25.
//

import Foundation

protocol RecipeServiceProtocol {
    func fetchRecipes() async throws -> RecipeList
}

class RecipeService : RecipeServiceProtocol {
    let networkClient: NetworkClientProtocol

    init(client: NetworkClientProtocol = NetworkClient()) {
        self.networkClient = client
    }

    func fetchRecipes() async throws -> RecipeList {
        let request = RecipesRequest()
        return try await networkClient.send(request)
    }
}
