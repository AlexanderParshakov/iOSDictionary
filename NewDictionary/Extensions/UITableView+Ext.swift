//
//  UITableView+Ext.swift
//  NewDictionary
//
//  Created by Alexander Parshakov on 11/13/19.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func isLastVisibleCell(at indexPath: IndexPath) -> Bool {
        guard let lastIndexPath = indexPathsForVisibleRows?.last else {
            return false
        }

        return lastIndexPath == indexPath
    }
}
