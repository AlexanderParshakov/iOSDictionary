//
//  TagClass.swift
//  WordList
//
//  Created by Alexander Parshakov on 17.10.2019.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import Foundation

class Tag: Decodable {
    
    var id: Int
    var name: String
    
    init(id:Int, name: String) {
        self.id = id
        self.name = name
    }
}
