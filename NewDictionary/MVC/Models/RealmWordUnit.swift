//
//  RealmWordUnit.swift
//  NewDictionary
//
//  Created by Alexander Parshakov on 11/3/19.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import Foundation
import RealmSwift

class RealmWordUnit: Object {
    
    @objc dynamic var id:String = ""
    @objc dynamic var content:String = ""
    @objc dynamic var meaning:String = ""
    @objc dynamic var example:String = ""
    @objc dynamic var note:String = ""
//    @objc dynamic var dateCreated: Date = Date()
    var tags: List<RealmWordTag> = List<RealmWordTag>()
    
    
    convenience init(wordUnit: WordUnit) {
        self.init()
        self.id = String(wordUnit.id)
        self.content = wordUnit.content
        self.meaning = wordUnit.meaning
        self.example = wordUnit.example
        self.note = wordUnit.note
        
        wordUnit.tags.forEach { (tag) in
            self.tags.append(RealmWordTag(tag: tag))
        }
//        guard let date = wordUnit.dateCreated else { return }
//        self.dateCreated = date
    }
}
