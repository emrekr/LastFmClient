//
//  ImageLoader.swift
//  LastFmClient
//
//  Created by Emre Kuru on 14.11.2024.
//

import UIKit

protocol ImageLoaderProtocol {
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void)
}

class ImageLoader: ImageLoaderProtocol {
    private let cache = NSCache<NSURL, UIImage>()
    private let queue = DispatchQueue(label: "image.loader.queue", qos: .userInitiated)

    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = cache.object(forKey: url as NSURL) {
            completion(cachedImage)
            return
        }

        queue.async {
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self, let data = data, let image = UIImage(data: data), error == nil else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
                }

                self.cache.setObject(image, forKey: url as NSURL)

                DispatchQueue.main.async {
                    completion(image)
                }
            }.resume()
        }
    }

    func clearCache() {
        cache.removeAllObjects()
    }
}
