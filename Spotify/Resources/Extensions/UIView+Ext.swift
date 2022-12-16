//
//  UIView+Ext.swift
//  Spotify
//
//  Created by Amini on 09/11/22.
//

import UIKit

extension UIView {
    func aspectRatio(_ ratio: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: self, attribute: .width, multiplier: ratio, constant: 0)
    }
    
    func rounded() {
        self.layer.cornerRadius = (self.frame.width / 2)
        self.layer.masksToBounds = true
    }
}
