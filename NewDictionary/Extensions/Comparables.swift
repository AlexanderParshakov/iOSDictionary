//
//  Comparables.swift
//  NewDictionary
//
//  Created by Alexander Parshakov on 11/9/19.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import Foundation

extension Tag: Comparable {
    static func > (lhs: Tag, rhs: Tag) -> Bool {
        return false
    }
    static func < (lhs: Tag, rhs: Tag) -> Bool {
           return false
       }
    
    static func == (lhs: Tag, rhs: Tag) -> Bool {
        if lhs.id == rhs.id {
            return true
        }
        return false
    }
}
