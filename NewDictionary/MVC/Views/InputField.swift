//
//  InputField.swift
//  NewDictionary
//
//  Created by Alexander Parshakov on 11/15/19.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class InputField: UITextView {
    
    @IBInspectable var UnderlineHeight: CGFloat = 2 {
        didSet {
            updateUnderline()
        }
    }
    
    func updateUnderline() {
        let line = UIView()
        line.backgroundColor = .systemRed
        addSubview(line)
        line.translatesAutoresizingMaskIntoConstraints = false
        line.heightAnchor.constraint(equalToConstant: UnderlineHeight).isActive = true
        line.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
        let margins = layoutMarginsGuide
        line.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 7).isActive = true
        
        
    }
}
