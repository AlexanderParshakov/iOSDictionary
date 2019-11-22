//
//  UILabelExtension.swift
//  NewDictionary
//
//  Created by Alexander Parshakov on 26.10.2019.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
  func addCharacterSpacing(kernValue: Double = 1.15) {
    if let labelText = text, labelText.count > 0 {
      let attributedString = NSMutableAttributedString(string: labelText)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
      attributedText = attributedString
    }
  }
}
