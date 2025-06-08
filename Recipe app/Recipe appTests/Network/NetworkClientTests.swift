//
//  NetworkClientTests.swift
//  Recipe app
//
//  Created by rahulKamra-1404 on 6/8/25.
//
import XCTest
@testable import Recipes

final class NetworkClientTests: XCTestCase {

    var networkClient: NetworkClient!

    override func setUp() {
        super.setUp()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        networkClient = NetworkClient(session: session)
        MockURLProtocol.responseData = nil
        MockURLProtocol.responseError = nil
    }

    func testSend_SuccessfulResponse() async throws {
        let expected = SampleResponse(message: "Hello World")
        let data = try JSONEncoder().encode(expected)
        MockURLProtocol.responseData = data

        let request = SampleRequest()
        let response = try await networkClient.send(request)

        XCTAssertEqual(response, expected)
    }

    func testSend_DecodingError() async throws {
            // Invalid JSON (empty data)
            MockURLProtocol.responseData = "{}".data(using: .utf8)

            let request = SampleRequest()

            do {
                _ = try await networkClient.send(request)
                XCTFail("Expected decoding error")
            } catch let error as NetworkError {
                XCTAssertEqual(error.userMessage, NetworkError.decodingError(error).userMessage)
            }
        }

    func testSend_RequestError() async throws {
            MockURLProtocol.responseError = URLError(.notConnectedToInternet)

            let request = SampleRequest()

            do {
                _ = try await networkClient.send(request)
                XCTFail("Expected network error")
            } catch let error as NetworkError {
                XCTAssertEqual(error.userMessage, NetworkError.requestFailed(error).userMessage)
            }
        }

    func testFetchData_Success() async throws {
            let expectedData = "Hello".data(using: .utf8)!
            MockURLProtocol.responseData = expectedData

            let data = try await networkClient.fetchData(from: URL(string: "https://example.com")!)
            XCTAssertEqual(data, expectedData)
        }
}
