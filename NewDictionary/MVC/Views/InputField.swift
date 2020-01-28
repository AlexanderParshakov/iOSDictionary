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
    
    @IBInspectable var underlineHeight: CGFloat = 2 {
        didSet {
            updateUnderline()
        }
    }
    @IBInspectable var underlineColor: UIColor = .systemRed {
        didSet {
            updateUnderline()
        }
    }
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        underlineColor = .systemRed
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
        return true
    }
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        underlineColor = .systemGray
        layoutIfNeeded()
        return true
    }
    
    func updateUnderline() {
        let line = UIView()
        line.backgroundColor = underlineColor
        addSubview(line)
        let margins = layoutMarginsGuide
        line.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 7).isActive = true
        line.translatesAutoresizingMaskIntoConstraints = false
        line.heightAnchor.constraint(equalToConstant: underlineHeight).isActive = true
        line.clipsToBounds = true
        clipsToBounds = true
        layoutIfNeeded()
        line.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
    }
}


@IBDesignable
class CustomTextField: UITextField {
    
    @IBInspectable var underlineHeight: CGFloat = 2 {
        didSet {
            updateUnderline()
        }
    }
    @IBInspectable var underlineColor: UIColor = .gray {
        didSet {
            updateUnderline()
        }
    }
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        underlineColor = .systemRed
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
        return true
    }
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        underlineColor = .systemBlue
        layoutIfNeeded()
        return true
    }
    
    func updateUnderline() {
        let line = UIView()
        line.backgroundColor = underlineColor
        addSubview(line)
        let margins = layoutMarginsGuide
        line.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 7).isActive = true
        line.translatesAutoresizingMaskIntoConstraints = false
        line.heightAnchor.constraint(equalToConstant: underlineHeight).isActive = true
        line.clipsToBounds = true
        clipsToBounds = true
        layoutIfNeeded()
        line.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
    }
}
