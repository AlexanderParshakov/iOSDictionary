//
//  RealmWordSource.swift
//  NewDictionary
//
//  Created by Alexander Parshakov on 11/25/19.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import Foundation
import RealmSwift

class RealmWordSource: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    
    convenience init(source: Source) {
        self.init()
        
        self.id = String(source.id)
        self.name = source.name
    }
}
