//
//  WordUnit.swift
//  Dictionary V.1.0
//
//  Created by Alexander Parshakov on 16/09/2019.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import Foundation

class WordUnitResults: Decodable {
    var results: [WordUnit]
}


class WordUnit: Decodable {
    
    var id:Int
    var content:String
    var meaning:String
    var example:String
    var note:String
    var dateCreated: Date?
    var tags: [Tag]
    
    
    init() {
        id = 0
        content = ""
        meaning = ""
        example = ""
        note = ""
        tags = [Tag]()
    }
    
    convenience init(word content:String, withId Id:Int, means meaning:String = "", withExample example:String = "", withNote note:String = "") {
        
        self.init()
        self.id = Id
        self.content = content
        self.meaning = meaning
        self.example = example
        self.note = note
        
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
