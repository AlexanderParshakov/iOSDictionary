//
//  UIView+Ext.swift
//  NewDictionary
//
//  Created by Alexander Parshakov on 11/14/19.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func setGradientBackground(colors: [CGColor], cornerRadius: CGFloat = 0) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.cornerRadius = cornerRadius
        clipsToBounds = true
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    func setSlightShadow(shadowColor: UIColor) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: 3, height:  3)
        self.layer.shadowRadius = 40
        self.layer.shadowOpacity = 0.3
    }
}
