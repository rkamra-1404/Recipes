//
//  MockImageCache.swift
//  Recipe app
//
//  Created by rahulKamra-1404 on 6/6/25.
//
@testable import Recipes
import UIKit

final class MockImageCache: ImageCaching {
    private var storage = [String: UIImage]()

    func image(forKey key: String) -> UIImage? {
        return storage[key]
    }

    func setImage(_ image: UIImage, forKey key: String) {
        storage[key] = image
    }
}
