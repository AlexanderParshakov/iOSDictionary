//
//  Source.swift
//  WordList
//
//  Created by Alexander Parshakov on 30/09/2019.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import Foundation
import UIKit

struct Source: Decodable {
    
    var id: Int
    var name: String
    var imageData: Data
    var wordUnits: [WordUnit]?
    
    init () {
        id = 0
        name = ""
        imageData = Data()
    }
    init(id: Int, name: String, imageData: Data) {
        self.id = id
        self.name = name
        self.imageData = imageData
    }
    
    init(realmSource: RealmSource) {
        self.init()
        
        self.id = Int(realmSource.id)!
        self.name = realmSource.name
        self.imageData = realmSource.imageData
        
        realmSource.realmWordUnits.forEach({ (realmWordUnit) in
            let wordUnit = WordUnit(realmWordUnit: realmWordUnit)
            self.wordUnits?.append(wordUnit)
        })
    }
}
