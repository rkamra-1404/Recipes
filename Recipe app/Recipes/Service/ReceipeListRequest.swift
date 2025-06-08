//
//  ReceipeListRequest.swift
//  Recipe app
//
//  Created by rahulKamra-1404 on 6/1/25.
//

import Foundation

struct RecipesRequest: Request {
    typealias ResponseType = RecipeList

    private let url: URL

    init(url: URL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!) {
        self.url = url
    }

    func build() -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}
