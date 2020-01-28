//
//  WordUnit.swift
//  Dictionary V.1.0
//
//  Created by Alexander Parshakov on 16/09/2019.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import Foundation

struct WordUnitResults: Decodable, Encodable {
    var results: [WordUnit]
}


struct WordUnit: Decodable, Encodable {
    
    var id:Int
    var content:String
    var meaning:String
    var example:String
    var note:String
    var dateCreated: String?
    var tags: [Tag]
    var source: Source
    var types: [TermType]
    var lang: Language
    
    
    init() {
        id = 0
        content = ""
        meaning = ""
        example = ""
        note = ""
        tags = [Tag]()
        source = Source()
        lang = Language()
        types = [TermType]()
    }
    init(realmWordUnit: RealmWordUnit) {
        self.init()
        self.id = Int(realmWordUnit.id)!
        self.content = realmWordUnit.content
        self.meaning = realmWordUnit.meaning
        self.example = realmWordUnit.example
        self.note = realmWordUnit.note
        
        if let source = realmWordUnit.source
        {
            self.source = Source(realmWordSource: source)
        }
        
        realmWordUnit.tags.forEach { (realmWordTag) in
            self.tags.append(Tag(realmWordTag: realmWordTag))
        }
    }
}

extension WordUnit {
    func isTagRelevant(content search:String) -> Bool {
        for tag in tags {
            if tag.name.lowercased().contains(search.lowercased()) {
                return true
            }
        }
        return false
    }
}
