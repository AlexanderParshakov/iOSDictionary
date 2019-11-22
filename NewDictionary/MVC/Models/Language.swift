//
//  Language.swift
//  NewDictionary
//
//  Created by Alexander Parshakov on 11/16/19.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import Foundation

final class Language: Decodable {
    
    var id: Int
    var name: String
    var location: String
    
    init() {
        self.id = 0
        self.name = ""
        self.location = ""
    }
    
    convenience init (realmLanguage: RealmLanguage) {
        self.init()
        self.id = Int(realmLanguage.id)!
        self.name = realmLanguage.name
        self.location = realmLanguage.location
    }
}
