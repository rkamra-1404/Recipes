//
//  RecipeListRequest.swift
//  Recipe app
//
//  Created by rahulKamra-1404 on 6/8/25.
//
import XCTest
@testable import Recipes

final class RecipesRequestTests: XCTestCase {

    func testBuild_CreatesValidURLRequest() {
        let url = URL(string: "https://example.com/test.json")!
        let request = RecipesRequest(url: url)
        let urlRequest = request.build()

        XCTAssertEqual(urlRequest.url, url)
        XCTAssertEqual(urlRequest.httpMethod, "GET")
    }

    func testDefaultURL_IsValid() {
        let request = RecipesRequest()
        let urlRequest = request.build()

        XCTAssertEqual(urlRequest.url?.absoluteString, "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")
    }
}
