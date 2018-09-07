//
//  JKMarkerView.swift
//  Jack
//
//  Created by Arthur Ngo Van on 06/06/2018.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit
import ArtUtilities

class JKMarkerView: AView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imageView: AUImageView!
    @IBOutlet weak var markerImage: UIImageView!
    
    var selected: Bool = false {
        didSet {
            let color = !selected ? UIColor.init(red: 88/255, green: 90/255, blue: 211/255, alpha: 1) : UIColor.init(red: 88/255, green: 206/255, blue: 211/255, alpha: 1)
            
            imageView.borderColor = color
        }
    }
    
    override func setUp() {
        Bundle.main.loadNibNamed("JKMarkerView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        imageView.frame = self.frame
        imageView.frame.size = CGSize.init(width: imageView.frame.width, height: imageView.frame.width)
        imageView.setUp()
    }
    
}
