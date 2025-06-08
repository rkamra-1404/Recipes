//
//  ImageCacheTests.swift
//  Recipe app
//
//  Created by r0k06op on 6/6/25.
//

import XCTest
@testable import Recipes

final class ImageCacheTests: XCTestCase {

    func testSetAndGetImageFromMemory() {
        let cache = ImageCache.shared
        let key = "memory-test"
        let image = UIImage(systemName: "star")!

        cache.setImage(image, forKey: key)
        let retrieved = cache.image(forKey: key)

        XCTAssertNotNil(retrieved)
        XCTAssertEqual(retrieved?.pngData(), image.pngData())
    }

    func testImageIsSavedToDiskAndLoaded() {
        let cache = ImageCache.shared
        let key = "disk-test"
        let image = UIImage(systemName: "circle")!

        cache.setImage(image, forKey: key)

        let expectation = XCTestExpectation(description: "Wait for disk write")
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(cache.image(forKey: key))
        // Clear in-memory cache (simulate app termination)
        cache.clearMemoryCache()
        // Simulate app relaunch
        let imageAfterRestart = cache.image(forKey: key)

        XCTAssertNotNil(imageAfterRestart, "Image should be loaded from disk after memory cache cleared")
    }

}
