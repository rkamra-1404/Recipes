//
//  MockUrlSession.swift
//  Recipe app
//
//  Created by rahulKamra-1404 on 6/6/25.
//
import Foundation
@testable import Recipes

class MockDataFetcher: DataFetcherProtocol {
    var dataToReturn: Data?
    var errorToThrow: Error?

    func fetchData(from url: URL) async throws -> Data {
        if let error = errorToThrow {
            throw error
        }
        return dataToReturn ?? Data()
    }
}
