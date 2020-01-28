//
//  PartOfSpeech.swift
//  NewDictionary
//
//  Created by Alexander Parshakov on 11/25/19.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import Foundation

final class TermType {
    var id: Int
    var name: String
    var isSelected: Bool = false
    
    init() {
        self.id = 0
        self.name = ""
    }
    
    convenience init (realmType: RealmType) {
        self.init()
        
        self.id = Int(realmType.id)!
        self.name = realmType.name
    }
}

extension TermType: Decodable, Encodable {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
}
