//
//  PartOfSpeechViewCell.swift
//  NewDictionary
//
//  Created by Alexander Parshakov on 11/25/19.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import UIKit

class TypeViewCell: UITableViewCell {

    @IBOutlet weak var typeNameLabel: UILabel!
    
    var type = TermType()
    
    func setType(type: TermType) {
        self.type = type
        
        typeNameLabel.text = type.name
        if type.isSelected {
            accessoryType = .checkmark
        }
        if !type.isSelected {
            accessoryType = .none
        }
    }
}
