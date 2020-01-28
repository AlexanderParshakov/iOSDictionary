//
//  GreetingViewController.swift
//  NewDictionary
//
//  Created by Alexander Parshakov on 12/5/19.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import UIKit

class GreetingViewController: UIViewController {
    
    // MARK: - Outlets:
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtons()
    }
    
    // MARK: - Actions
    @IBAction func onSignInButtonTapped(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Authentication", bundle: Bundle.main)
        if let viewController = mainStoryboard.instantiateViewController(withIdentifier: "signInScreen") as? SignInViewController {
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true, completion: nil)
        }
    }
    @IBAction func onSignUpButtonTapped(_ sender: Any) {
        
    }
    
    
    // MARK: - Functions
    func setupButtons() {
        let buttons = [signInButton, signUpButton]
        
        buttons.forEach { (button) in
            button?.layer.cornerRadius = 10
        }
    }
}
