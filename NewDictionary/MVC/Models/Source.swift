//
//  Source.swift
//  WordList
//
//  Created by Alexander Parshakov on 30/09/2019.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import Foundation
import UIKit

class Source: NSObject, Decodable, Encodable, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    
    
    var id: Int
    var name: String
    var imageData: Data?
    var wordUnits: [WordUnit]?
    
    override init () {
        id = 0
        name = ""
        imageData = Data()
    }
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeInteger(forKey: "id")
        let name = aDecoder.decodeObject(forKey: "name") as! String
        self.init(id: id, name: name, imageData: nil)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
    }
    convenience init(id: Int, name: String, imageData: Data?) {
        self.init()
        self.id = id
        self.name = name
        self.imageData = imageData
    }
    
    convenience init(realmSource: RealmSource) {
        self.init()
        
        self.id = Int(realmSource.id)!
        self.name = realmSource.name
        self.imageData = realmSource.imageData
        
        realmSource.realmWordUnits.forEach({ (realmWordUnit) in
            let wordUnit = WordUnit(realmWordUnit: realmWordUnit)
            self.wordUnits?.append(wordUnit)
        })
    }
    convenience init (realmWordSource: RealmWordSource) {
        self.init()
        
        self.id = Int(realmWordSource.id)!
        self.name = realmWordSource.name
    }
    
}
