//
//  StringExtension.swift
//  NewDictionary
//
//  Created by Alexander Parshakov on 11/11/19.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import Foundation

extension String {
    mutating func addSideQuotes() {
        guard self.count != 0 else { return }
        self = "\"" + self + "\""
    }
    mutating func removeSideQuotes() {
        if self.hasPrefix("\"") {
            self.removeFirst()
        }
        if self.hasSuffix("\"") {
            self.removeLast()
        }
    }
}
