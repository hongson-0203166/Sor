//
//  ImageLoader.swift
//  Sor
//
//  Created by Phạm Hồng Sơn on 29/09/2024.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class ImageLoader: UIImageView {

    var imageURL: URL?

    func loadImageWithUrl(_ urlStr: String?, defaultImage: UIImage? = R.image.ic_df1()) {
        guard let urlStr, let url = URL(string: urlStr.replacingOccurrences(of: " ", with: "%20")) else {return}
        
        imageURL = url

        image = defaultImage
        
        // retrieves image if already available in cache
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {

            self.image = imageFromCache
            return
        }

        // image does not available in cache.. so retrieving it from url...
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in

            if error != nil {
                return
            }

            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else {return}

                if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {
                    if self.imageURL == url {
                        self.image = imageToCache
                    }
                    imageCache.setObject(imageToCache, forKey: url as AnyObject)
                }
            }
        }).resume()
    }
}
