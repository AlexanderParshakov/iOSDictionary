//
//  SignInViewController.swift
//  NewDictionary
//
//  Created by Alexander Parshakov on 12/5/19.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import UIKit
import JGProgressHUD
import IQKeyboardManager

class SignInViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var wrappingView: UIView!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    // MARK: - Constraints
    @IBOutlet weak var wrappingViewCenterYConstraint: NSLayoutConstraint!
    
    // MARK: - Actions
    @IBAction func onSignInButtonTapped(_ sender: Any) {
        let hud = JGProgressHUD(style: .extraLight)
        hud.cornerRadius = 15
        hud.hudView.backgroundColor = .systemRed
        hud.vibrancyEnabled = true
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 1)
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let viewController = mainStoryboard.instantiateViewController(withIdentifier: Constants.Identifiers.tabBarScreen) as? UITabBarController {
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true, completion: nil)
        }
    }
    @IBAction func onSignUpButtonTapped(_ sender: Any) {
        
    }
    
    
    // MARK: - Variables
    var wrappingViewCenterYOriginalConstraint: CGFloat = 0

    let moveUpDistance: CGFloat = 150
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        defer {
            addObservers()
        }
        
        setupSignInButton()
        setupWrappingView()
        changeColorsForTheme()
        
        IQKeyboardManager.shared().toolbarTintColor = .systemRed
    }
    
    // MARK: - Functions
    func setupSignInButton() {
        signInButton.contentVerticalAlignment = .center
        signInButton.setTitleColor(UIColor.white, for: .normal)
        signInButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
        signInButton.titleLabel?.textColor = UIColor.white
        
        signUpButton.layer.cornerRadius = 10
        signInButton.applyGradient(colors: Constants.Colors.GradientSets.burningOrange)
        wrappingView.bringSubviewToFront(signUpButton)
    }
    func setupWrappingView() {
        wrappingViewCenterYOriginalConstraint = wrappingViewCenterYConstraint.constant
        wrappingView.layer.cornerRadius = 15
    }
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - Keyboard Moveup Handling
extension SignInViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        if wrappingViewCenterYConstraint.constant == wrappingViewCenterYOriginalConstraint {
            wrappingViewCenterYConstraint.constant -= moveUpDistance
        }
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        wrappingViewCenterYConstraint.constant += moveUpDistance
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
}


// MARK: - Trait Collection
extension SignInViewController {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            switch UIScreen.main.traitCollection.userInterfaceStyle {
                case .light:
                    changeColors(colors: Constants.Colors.GradientSets.relaxingRed)
                    wrappingView.setSlightShadow(shadowColor: .systemGray)
                case .dark: changeColors(colors: Constants.Colors.GradientSets.deepSpace)
                case .unspecified: changeColors(colors: Constants.Colors.GradientSets.relaxingRed)
                @unknown default:
                    changeColors(colors: Constants.Colors.GradientSets.relaxingRed)
            }
    }
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        
    }
    func changeColorsForTheme() {
        switch UIScreen.main.traitCollection.userInterfaceStyle {
            case .light:
                changeColors(colors: Constants.Colors.GradientSets.relaxingRed)
                wrappingView.setSlightShadow(shadowColor: .systemGray)
            case .dark: changeColors(colors: Constants.Colors.GradientSets.deepSpace)
            case .unspecified: changeColors(colors: Constants.Colors.GradientSets.relaxingRed)
            @unknown default:
                changeColors(colors: Constants.Colors.GradientSets.relaxingRed)
        }
    }
    func changeColors(colors: [CGColor]) {
        wrappingView.setGradientBackground(colors: colors, cornerRadius: wrappingView.layer.cornerRadius)
        view.setGradientBackground(colors: colors)
    }
}
