//
//  SettingsViewController.swift
//  WordList
//
//  Created by Alexander Parshakov on 10.10.2019.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import UIKit

class SettingsScreen: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Constants.Localizables.Settings.mainTitle
        self.navigationController?.navigationBar.topItem?.title = Constants.Localizables.Settings.mainTitle
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
}
