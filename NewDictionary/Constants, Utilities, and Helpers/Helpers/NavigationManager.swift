//
//  NavigationManager.swift
//  NewDictionary
//
//  Created by Alexander Parshakov on 1/27/20.
//  Copyright © 2020 Alexander Parshakov. All rights reserved.
//

import Foundation
import UIKit
import Hero

final class NavigationManager {
    
    private static func removeButtonsFromNavigation(viewController vc: UIViewController) {
        switch vc {
            case is DictionaryScreen:
                vc.navigationController?.view.subviews.forEach({ (view) in
                    if view is UIButton && view.tag == Constants.Tags.TermReadyButtonTag {
                        view.removeFromSuperview()
                    }
                })
            case is AddWordScreen:
                vc.navigationController?.view.subviews.forEach({ (view) in
                    if view is UIButton && view.tag == Constants.Tags.AddTermButtonTag {
                        view.removeFromSuperview()
                    }
                })
            default:
                return
        }
        
    }
    
    static func setupAddButton(viewController vc: UIViewController) {
        removeButtonsFromNavigation(viewController: vc)
        
        let xPoint: CGFloat
        let yPoint: CGFloat
        let buttonPoint: CGPoint
        let buttonSize: CGSize
        var button: UIButton = UIButton()
        
        switch vc {
            case is DictionaryScreen:
                xPoint = vc.view.frame.width - vc.view.frame.width * 0.22
                yPoint = vc.view.frame.size.height - vc.view.frame.size.height * 0.19
                buttonPoint = CGPoint(x: xPoint, y: yPoint)
                buttonSize = CGSize(width: 55, height: 55)
            case is AddWordScreen:
                xPoint = vc.view.frame.width - vc.view.frame.width * 0.9
                yPoint = vc.view.frame.size.height - 150
                buttonPoint = CGPoint(x: xPoint, y: yPoint)
                buttonSize = CGSize(width: vc.view.frame.width * 0.8, height: 50)
            default:
                xPoint = vc.view.frame.width - vc.view.frame.width * 0.22
                yPoint = vc.view.frame.size.height - vc.view.frame.size.height * 0.19
                buttonPoint = CGPoint(x: xPoint, y: yPoint)
                buttonSize = CGSize(width: 55, height: 55)
        }
        
        let buttonRect = CGRect(origin: buttonPoint, size: buttonSize)
        button = UIButton(frame: buttonRect)
        switch vc {
            case is DictionaryScreen:
                button.setImage(UIImage(systemName: "plus"), for: .normal)
                button.tag = Constants.Tags.AddTermButtonTag
            case is AddWordScreen:
                button.setTitle("My term is ready", for: .normal)
                button.setTitle("My term is ready", for: .disabled)
                button.setImage(UIImage(systemName: "checkmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)), for: .normal)
                button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
                button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 255, bottom: 0, right: 0)
                button.tag = Constants.Tags.TermReadyButtonTag
            default:
                return
        }
        button.tintColor = .white
        button.hero.id = Constants.Identifiers.Hero.addTermButton
        
        button.layer.cornerRadius = button.frame.height/2
        
        button.applyGradient(colors: Constants.Colors.GradientSets.burningOrange, cornerRadius: button.layer.cornerRadius)
        if let imageView = button.imageView {
            button.bringSubviewToFront(imageView)
        }
        vc.navigationController?.view.addSubview(button)
    }
}
