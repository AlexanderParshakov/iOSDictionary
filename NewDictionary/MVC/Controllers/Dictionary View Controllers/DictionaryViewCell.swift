//
//  WordViewCell.swift
//  WordList
//
//  Created by Alexander Parshakov on 26/09/2019.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import UIKit

class DictionaryViewCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var meaningLabel: UILabel!
    
    func setWord(word: WordUnit) {
        contentLabel.text = word.content
        meaningLabel.text = word.meaning
    }
    
}
