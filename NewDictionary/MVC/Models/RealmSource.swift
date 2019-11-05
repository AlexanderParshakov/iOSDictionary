//
//  RealmSource.swift
//  NewDictionary
//
//  Created by Alexander Parshakov on 11/3/19.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import Foundation
import RealmSwift

class RealmSource: Object {
    
    
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var imageData: Data = Data()
    var realmWordUnits: List<RealmWordUnit> = List<RealmWordUnit>()
    
    convenience init(source: Source) {
        self.init()
        
        self.id = String(source.id)
        self.name = source.name
        self.imageData = source.imageData
        
        source.wordUnits?.forEach({ (wordUnit) in
            let realmWordUnit = RealmWordUnit(wordUnit: wordUnit)
            self.realmWordUnits.append(realmWordUnit)
        })
    }
}
