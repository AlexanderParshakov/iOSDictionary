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
    @IBOutlet weak var customBackgroundView: UIView!
    @IBOutlet weak var sourceLabel: UILabel!
    
    var wordUnit: WordUnit = WordUnit()
    
    func setWord(word: WordUnit) {
        self.wordUnit = word
        contentLabel.text = word.content
        meaningLabel.text = word.meaning
        if sourceLabel != nil {
            sourceLabel.text = word.source.name
        }
        setupBackgroundView()
    }
    func setupBackgroundView() {
        selectionStyle = .none
        backgroundColor = .clear
        customBackgroundView.layer.cornerRadius = 15
        customBackgroundView.setSlightShadow(shadowColor: .systemGray)
    }
}
