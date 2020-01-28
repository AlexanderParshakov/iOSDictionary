//
//  SettingsViewController.swift
//  WordList
//
//  Created by Alexander Parshakov on 10.10.2019.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import UIKit

class SettingsScreen: UITableViewController {
    @IBOutlet var settingsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Constants.Localizables.Settings.mainTitle
        self.navigationController?.navigationBar.topItem?.title = Constants.Localizables.Settings.mainTitle
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension SettingsScreen {
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (section == 0)
        {
            return 40.0;
        }
        if (section == 1)
        {
            return 150.0;
        }
        else
        {
            return .leastNormalMagnitude;
        }
    }
}

