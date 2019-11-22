//
//  CustomButton.swift
//  NewDictionary
//
//  Created by Alexander Parshakov on 11/6/19.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import Foundation
import UIKit

class CustomButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    func setupButton() {
        clipsToBounds = true
        layer.masksToBounds = false
        
        
    }
}
