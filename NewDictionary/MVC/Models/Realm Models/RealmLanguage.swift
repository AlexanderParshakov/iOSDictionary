//
//  RealmLanguage.swift
//  NewDictionary
//
//  Created by Alexander Parshakov on 11/16/19.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import Foundation
import RealmSwift

class RealmLanguage: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var location: String = ""
    
    convenience init(language: Language) {
        self.init()
        
        self.id = String(language.id)
        self.name = language.name
        self.location = language.location
    }
}
