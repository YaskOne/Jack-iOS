//
//  JKImageLoader.swift
//  Jack
//
//  Created by Arthur Ngo Van on 11/06/2018.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import Foundation

class JKImageLoader {
    
    static func loadImage(imageView: UIImageView?, url: String, error: @escaping () -> Void) {
        if let image = JKImageCache.shared.getObject(key: url) {
            imageView?.image = image
            imageView?.isHidden = false
        }
        else {
            imageView?.imageFromURL(urlString: url) { image in
                JKImageCache.shared.addObject(key: url, object: image)
            }
        }
    }
    
}
