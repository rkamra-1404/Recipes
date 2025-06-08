//
//  ImageLoaderTests.swift
//  Recipe app
//
//  Created by r0k06op on 6/6/25.
//

import XCTest
@testable import Recipes
import UIKit

final class ImageLoaderTests: XCTestCase {

    @MainActor
    func testLoadsImageFromCache() async throws {
        let mockCache = MockImageCache()
        let testImage = UIImage(systemName: "star")!
        let urlString =  "https://example.com/image.png"
        let cacheKey = String(urlString.hashValue)
        mockCache.setImage(testImage, forKey: cacheKey)

        let loader = ImageLoader(cache: mockCache)
        loader.load(urlString: urlString)

        try await Task.sleep(for: .milliseconds(100))
        XCTAssertEqual(loader.image?.pngData(), testImage.pngData())
    }

    @MainActor
    func testLoadsImageFromNetworkAndCachesIt() async throws {
        let mockCache = MockImageCache()
        let testImage = UIImage(systemName: "star")!
        let imageData = testImage.pngData()!
        let urlString =  "https://example.com/image.png"

        let mockFetcher = MockDataFetcher()
        mockFetcher.dataToReturn = imageData
        let loader = ImageLoader(cache: mockCache, networkClient: mockFetcher)
        loader.load(urlString: urlString)
        try? await Task.sleep(nanoseconds: 500_000_000)
        XCTAssertNotNil(loader.image)

        // Also verify cache contains image
        let cachedImage = mockCache.image(forKey: String(urlString.hashValue))
        XCTAssertNotNil(cachedImage)
    }

    @MainActor
    func testLoadImage_Failure() async {
        let mockCache = MockImageCache()
        let mockFetcher = MockDataFetcher()
        mockFetcher.errorToThrow = URLError(.notConnectedToInternet)

        let loader = ImageLoader(cache: mockCache, networkClient: mockFetcher)

        let urlString = "https://example.com/image.png"
        loader.load(urlString: urlString)

        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 sec

        XCTAssertNil(loader.image)
    }
}
