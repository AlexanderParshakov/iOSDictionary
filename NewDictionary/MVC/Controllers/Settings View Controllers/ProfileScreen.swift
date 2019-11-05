//
//  ProfileViewController.swift
//  NewDictionary
//
//  Created by Alexander Parshakov on 10/31/19.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import UIKit

class ProfileScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Constants.Localizables.Settings.myProfile
        self.navigationController!.navigationBar.tintColor = Constants.Colors.deepRed;
    }
}
