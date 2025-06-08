//
//  MockRequest.swift
//  Recipe app
//
//  Created by rahulKamra-1404 on 6/8/25.
//
@testable import Recipes
import Foundation

struct SampleResponse: Codable, Equatable {
    let message: String
}

struct SampleRequest: Request {
    typealias ResponseType = SampleResponse

    func build() -> URLRequest {
        return URLRequest(url: URL(string: "https://example.com/api")!)
    }
}
