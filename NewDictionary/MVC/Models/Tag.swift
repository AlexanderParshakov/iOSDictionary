//
//  TagClass.swift
//  WordList
//
//  Created by Alexander Parshakov on 17.10.2019.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import Foundation

struct Tag: Decodable {
    
    var id: Int
    var name: String
    
    init() {
        self.id = 0
        self.name = ""
    }
    
    init (realmTag: RealmTag) {
        self.init()
        
        self.id = Int(realmTag.id)!
        self.name = realmTag.name
    }
}
