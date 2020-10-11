//
//  ImageLoader.swift
//  FightClubTMDB
//
//  Created by Shaunak Jagtap on 11/10/20.
//  Copyright © 2020 shaunak. All rights reserved.
//

import UIKit

class ImageLoader {

    var task: URLSessionDownloadTask!
    var session = URLSession(configuration: .default)
    var cache: NSCache<NSString, UIImage>!

    init() {
        session = URLSession.shared
        self.cache = NSCache()
    }

    func obtainImageWithPath(imagePath: String, completionHandler: @escaping (UIImage) -> ()) {
        if let image = self.cache.object(forKey: imagePath as NSString) {
            DispatchQueue.main.async {
                completionHandler(image)
            }
        } else {
            guard let placeholder = UIImage(named: "movie-ticket") else { return }
            DispatchQueue.main.async {
                completionHandler(placeholder)
            }
            if let url = URL(string: imagePath) {
                task = session.downloadTask(with: url, completionHandler: { (location, response, error) in
                    if let data = try? Data(contentsOf: url) {
                        let img: UIImage! = UIImage(data: data)
                        self.cache.setObject(img, forKey: imagePath as NSString)
                        DispatchQueue.main.async {
                            completionHandler(img)
                        }
                    }
                })
                task.resume()
            } else {
                print(Constants.errors.errorLoadingImage)
            }
        }
    }
}
