//
//  NetworkClient.swift
//  Recipe app
//
//  Created by rahulKamra-1404 on 6/1/25.
//

import Foundation

protocol Request {
    associatedtype ResponseType: Decodable
    func build() -> URLRequest
}

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case noData
    case decodingError(Error)

    var userMessage: String {
            switch self {
            case .invalidURL:
                return "Invalid request. Please contact support."
            case .noData:
                return "No data was received from the server."
            case .requestFailed:
                return "Network issue. Please check your connection."
            case .decodingError:
                return "Data format error. Please try again later."
            }
        }
}

protocol NetworkClientProtocol {
    func send<T: Request>(_ request: T) async throws -> T.ResponseType
}

protocol DataFetcherProtocol {
    func fetchData(from url: URL) async throws -> Data
}

class NetworkClient : NetworkClientProtocol {
    private let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func send<T: Request>(_ request: T) async throws -> T.ResponseType {
        let urlRequest = request.build()

        do {
            let (data, _) = try await session.data(for: urlRequest)
            let response = try JSONDecoder().decode(T.ResponseType.self, from: data)
            return response
        } catch let decodingError as DecodingError {
            print("Decoding Error: \(decodingError.localizedDescription)")
            throw NetworkError.decodingError(decodingError)
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }
}

extension NetworkClient: DataFetcherProtocol {
    func fetchData(from url: URL) async throws -> Data {
        let request = URLRequest(url: url)
        let (data, _) = try await session.data(for: request)
        return data
    }
}
