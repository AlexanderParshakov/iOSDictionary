//
//  Localizer.swift
//  NewDictionary
//
//  Created by Alexander Parshakov on 11/1/19.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import Foundation

struct Localizer {
    
    private init() {}
    
    static func Localize(_ localizableKey:String) -> String {
        return NSLocalizedString(localizableKey, comment: "")
    }
}
