//
//  SourcesViewCell.swift
//  WordList
//
//  Created by Alexander Parshakov on 30/09/2019.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import UIKit

class SourcesViewCell: UITableViewCell {
    
    
    @IBOutlet weak var sourceImage: UIImageView!
    @IBOutlet weak var sourceName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        sourceImage.layer.masksToBounds = true
        sourceImage.layer.cornerRadius = 15
//        sourceImage.layer.borderWidth = 4
//        sourceImage.layer.borderColor = UIColor.systemRed.cgColor
        
    }
    
    
    func setSource(source: Source) {
        sourceName.text = source.name
        sourceImage.image = UIImage(data: source.imageData)
    }
}
