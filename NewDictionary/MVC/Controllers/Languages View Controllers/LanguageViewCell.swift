//
//  LanguageViewCell.swift
//  NewDictionary
//
//  Created by Alexander Parshakov on 11/16/19.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import UIKit

class LanguageViewCell: UITableViewCell {
    
    @IBOutlet weak var customBackgroundView: UIView!
    @IBOutlet weak var languageNameAndLocLabel: UILabel!
    
    var language: Language = Language()
    
    
    func setLanguage(lang: Language) {
        language = lang
        languageNameAndLocLabel.text = lang.name + " (" + lang.location + ")"
        
        setupBackgroundView()
    }
    func setupBackgroundView() {
        selectionStyle = .none
        backgroundColor = .clear
        customBackgroundView.layer.cornerRadius = 10
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
