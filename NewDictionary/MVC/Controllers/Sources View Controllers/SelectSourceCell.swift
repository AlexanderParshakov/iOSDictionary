//
//  SelectSourceCell.swift
//  NewDictionary
//
//  Created by Alexander Parshakov on 11/17/19.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import UIKit

class SelectSourceCell: UITableViewCell {
    
    @IBOutlet weak var sourceName: UILabel!
    @IBOutlet weak var sourceImage: UIImageView!
    
    var source: Source = Source()
    

    override func awakeFromNib() {
            super.awakeFromNib()
            sourceImage.layer.masksToBounds = true
            sourceImage.layer.cornerRadius = 15
            
        }
        
        
        func setSource(source: Source) {
            self.source = source
            sourceName.text = source.name
            guard let imageData = source.imageData else { return }
            sourceImage.image = UIImage(data: imageData)
        }
}
