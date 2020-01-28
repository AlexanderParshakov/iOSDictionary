//
//  AddTagsCell.swift
//  NewDictionary
//
//  Created by Alexander Parshakov on 11/7/19.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import UIKit
import Lottie

class AddTagsCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    var tagVariable:Tag? = nil
    
    func setTag(tag: Tag) {
        tagVariable = tag
        nameLabel.text = tag.name
        setCheckmark(selected: tag.isSelected)
        
    }
    func setCheckmark(selected: Bool) {
        if selected { accessoryType = .checkmark }
        else { accessoryType = .none }
    }
}
