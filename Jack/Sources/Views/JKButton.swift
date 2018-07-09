//
//  JKButton.swift
//  Jack
//
//  Created by Arthur Ngo Van on 06/06/2018.
//  Copyright © 2018 Arthur Ngo Van. All rights reserved.
//

import UIKit

@IBDesignable class JKButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var cornerRadiusRatio: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadiusRatio * frame.height
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUp()
    }
    
    func setUp() {
        self.clipsToBounds = true
        self.contentMode = UIViewContentMode.scaleAspectFit
        
        layer.cornerRadius = cornerRadius
        layer.cornerRadius = cornerRadiusRatio * frame.height
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
    
    @IBInspectable var blured: Bool = false {
        didSet {
            if blured {
                blur()
            }
            else {
                unblur()
            }
        }
    }
    
    var blurView: UIView?
}

extension JKButton
{
    func blur() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        self.blurView = UIVisualEffectView(effect: blurEffect)
        blurView?.frame = self.bounds
        blurView?.isUserInteractionEnabled = false
        
        blurView?.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurView!)
    }
    
    func unblur() {
        blurView?.removeFromSuperview()
    }
}
