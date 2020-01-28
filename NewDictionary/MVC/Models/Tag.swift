//
//  TagClass.swift
//  WordList
//
//  Created by Alexander Parshakov on 17.10.2019.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import Foundation

final class Tag {
    
    var id: Int
    var name: String
    var isSelected: Bool = false
    
    init() {
        self.id = 0
        self.name = ""
    }
    convenience init(name: String, isSelected: Bool) {
        self.init()
        
        self.id = 0
        self.name = name
        self.isSelected = isSelected
    }
    convenience init (realmWordTag: RealmWordTag) {
        self.init()
        
        self.id = Int(realmWordTag.id)!
        self.name = realmWordTag.name
    }
    convenience init (realmTag: RealmTag) {
        self.init()
        
        self.id = Int(realmTag.id)!
        self.name = realmTag.name
    }
}

extension Tag: Decodable, Encodable {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
}
