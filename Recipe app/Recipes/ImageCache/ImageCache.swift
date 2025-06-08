//
//  ImageCache.swift
//  Recipe app
//
//  Created by rahulKamra-1404 on 6/2/25.
//
import Foundation
import UIKit

protocol ImageCaching {
    func image(forKey key: String) -> UIImage?
    func setImage(_ image: UIImage, forKey key: String)
}

final class ImageCache: ImageCaching {
    static let shared = ImageCache()
    private init() {}

    private let cache = NSCache<NSString, UIImage>()
    private let ioQueue = DispatchQueue(label: "com.example.ImageCache.ioQueue")

    private lazy var diskCacheUrl: URL = {
        let fileManager = FileManager.default
        let caches = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let cacheDirectoryUrl = caches.appendingPathComponent("CustomImageCache")
        if !FileManager.default.fileExists(atPath: cacheDirectoryUrl.path) {
            try? fileManager.createDirectory(at: cacheDirectoryUrl, withIntermediateDirectories: true)
        }
        return cacheDirectoryUrl
    }()

    func image(forKey key: String) -> UIImage? {
        if let cachedImage = cache.object(forKey: key as NSString) {
            return cachedImage
        }
        
        if let diskImage = loadImageFromDisk(key: key) {
            cache.setObject(diskImage, forKey: key as NSString)
            return diskImage
        }
        return nil
    }

    func loadImageFromDisk(key: String) -> UIImage? {
        let fullPath = diskCacheUrl.appendingPathComponent(key)
        guard FileManager.default.fileExists(atPath: fullPath.path) else {
            return nil
        }
        do {
            let data = try Data(contentsOf: fullPath)
            return UIImage(data: data)
        } catch {
            print("Error loading image from disk: \(error)")
            return nil
        }
    }

    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
        ioQueue.async {
            self.saveImageToDisk(image, forKey: key)
        }
    }

    private func saveImageToDisk(_ image: UIImage, forKey key: String) {
        let fullPath = self.diskCacheUrl.appendingPathComponent(key)
        guard let data = image.pngData() else {
            print("Error converting image to PNG data.")
            return
        }
        do {
            try data.write(to: fullPath)
        } catch {
            print("Error saving image to disk: \(error)")
        }
    }
}

// MARK: - Test Hooks (for Unit Testing)

#if DEBUG
extension ImageCache {
    /// Clear in-memory cache to simulate app restart
    func clearMemoryCache() {
        cache.removeAllObjects()
    }
}
#endif
