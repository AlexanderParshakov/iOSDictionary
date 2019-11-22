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
    
    var wordUnit: WordUnit = WordUnit()
    
    func setWord(word: WordUnit) {
        self.wordUnit = word
        contentLabel.text = word.content
        meaningLabel.text = word.meaning
        setupBackgroundView()
    }
    func setupBackgroundView() {
        selectionStyle = .none
        backgroundColor = .clear
//        customBackgroundView.backgroundColor = Constants.Colors.darkGrey
        customBackgroundView.layer.cornerRadius = 15
    }
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
//    }
}
