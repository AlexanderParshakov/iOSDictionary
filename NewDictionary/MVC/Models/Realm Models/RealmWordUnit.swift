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
    @objc dynamic var source:RealmWordSource?
    @objc dynamic var lang:RealmLanguage?
    @objc dynamic var dateCreated: String = ""
    var tags: List<RealmWordTag> = List<RealmWordTag>()
    var types: List<RealmWordType> = List<RealmWordType>()
    
    
    convenience init(wordUnit: WordUnit) {
        self.init()
        self.id = String(wordUnit.id)
        self.content = wordUnit.content
        self.meaning = wordUnit.meaning
        self.example = wordUnit.example
        self.note = wordUnit.note
        if let date = wordUnit.dateCreated {
            self.dateCreated = date
        }
        self.source = RealmWordSource(source: wordUnit.source)
        
        wordUnit.tags.forEach { (tag) in
            self.tags.append(RealmWordTag(tag: tag))
        }
        wordUnit.types.forEach { (type) in
            self.types.append(RealmWordType(type: type))
        }
//        guard let date = wordUnit.dateCreated else { return }
//        self.dateCreated = date
    }
}
