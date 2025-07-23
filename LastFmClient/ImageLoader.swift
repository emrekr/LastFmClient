//
//  ImageLoader.swift
//  LastFmClient
//
//  Created by Emre Kuru on 14.11.2024.
//

import UIKit
import Combine

protocol ImageLoaderProtocol {
    func loadImage(from url: URL) async -> UIImage?
    func cancelLoad(for url: URL) async
    func clearCache() async
}

actor ImageLoader: ImageLoaderProtocol {
    
    private let cache = NSCache<NSURL, UIImage>()
    private var runningRequests: [URL: Task<UIImage?, Never>] = [:]

    func loadImage(from url: URL) async -> UIImage? {
        // Return cached if available
        if let cached = cache.object(forKey: url as NSURL) {
            return cached
        }

        // Avoid duplicate loading
        if let task = runningRequests[url] {
            return await task.value
        }

        // Start new load task
        let task = Task<UIImage?, Never> {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    cache.setObject(image, forKey: url as NSURL)
                    return image
                }
            } catch {
                return nil
            }
            return nil
        }

        runningRequests[url] = task
        let image = await task.value
        runningRequests.removeValue(forKey: url)
        return image
    }

    func cancelLoad(for url: URL) {
        runningRequests[url]?.cancel()
        runningRequests.removeValue(forKey: url)
    }

    func clearCache() {
        cache.removeAllObjects()
    }
}


