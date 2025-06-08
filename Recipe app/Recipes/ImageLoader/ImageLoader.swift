//
//  ImageLoader.swift
//  Recipe app
//
//  Created by rahulKamra-1404 on 6/2/25.
//
import Foundation
import UIKit


@MainActor
final class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private var isLoading = false
    private var task: Task<Void, Never>?
    private let cache: ImageCaching
    private let networkClient: DataFetcherProtocol

    init(cache: ImageCaching = ImageCache.shared,
         networkClient: DataFetcherProtocol = NetworkClient()) {
        self.cache = cache
        self.networkClient = networkClient
    }
    func load(urlString: String) {
        guard !isLoading else { return }
        isLoading = true

        if let cachedImageData = cache.image(forKey: cacheKey(for: urlString)) {
            self.image = cachedImageData
            return
        }
        task?.cancel()
        guard let url = URL(string: urlString) else { return }

        task = Task {
            do {
                let data = try await networkClient.fetchData(from: url)
                guard let image = UIImage(data: data) else { return }
                self.image = image
                cache.setImage(image, forKey: cacheKey(for: urlString))
            } catch {
                print("Image download failed: \(error.localizedDescription)")
            }
        }
    }

    private func cacheKey(for urlString: String) -> String {
        return String(urlString.hashValue)
    }

    func cancel() {
        task?.cancel()
    }

}
