//
//  MockData.swift
//  WordList
//
//  Created by Alexander Parshakov on 01/10/2019.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import Foundation
import UIKit

class StubManipulator {
    
    private init() {}
    
    static var sources: [Source]  {
        return fetchSources()
    }
    private static func fetchSources() -> [Source] {
        let sourceList = [Source]()
        
//        let lucifer = Source(context: PersistenceService.context)
//        lucifer.name = "Lucifer"
//        lucifer.image = UIImage(named: "Sources/Lucifer")!.jpegData(compressionQuality: 1.0)
//        let temp = wordUnits[0]
//        lucifer.addToWordUnits(temp)
//        lucifer.addToWordUnits(wordUnits[1])
//        lucifer.addToWordUnits(wordUnits[2])
//        let strangerThings = Source(context: PersistenceService.context)
//        strangerThings.name = "Stranger Things"
//        strangerThings.image = UIImage(named: "Sources/Stranger Things")!.jpegData(compressionQuality: 1.0)
//        let gameOfThrones = Source(context: PersistenceService.context)
//        gameOfThrones.name = "Game of Thrones"
//        gameOfThrones.image = UIImage(named: "Sources/Game of Thrones")!.jpegData(compressionQuality: 1.0)
//        
//        sourceList.append(lucifer)
//        sourceList.append(strangerThings)
//        sourceList.append(gameOfThrones)
        return sourceList
    }
}
