//
//  Animations.swift
//  NewDictionary
//
//  Created by Alexander Parshakov on 11/13/19.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import Foundation
import UIKit
typealias CustomAnimation = (UITableViewCell, IndexPath, UITableView) -> Void

final class Animator {
    private let animation: CustomAnimation
    
    private static var timer: Timer = Timer()
    
    init(animation: @escaping CustomAnimation) {
        self.animation = animation
    }
    
    func animate(cell: UITableViewCell, at indexPath: IndexPath, in tableView: UITableView) {
        animation(cell, indexPath, tableView)
        
    }
    static func animateLabelColor(firstColor: UIColor, secondColor: UIColor, label: UILabel, additionalScale: Double = 0.05) {
        let changeColor = CATransition()
        changeColor.type = CATransitionType.fade
        changeColor.duration = 0.3
        //        changeColor.startProgress = 0.5
        
        
        CATransaction.setCompletionBlock {
            self.timer.invalidate()
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: { (_) in
                label.textColor = secondColor
                label.layer.add(changeColor, forKey: nil)
                UIView.animate(withDuration: 0.3) {
                    label.transform = CGAffineTransform(scaleX: 1, y: 1) //Scale label area
                }
            })
        }
        
        CATransaction.begin()
        label.textColor = firstColor
        label.layer.add(changeColor, forKey: nil)
        UIView.animate(withDuration: 0.3) {
            label.transform = CGAffineTransform(scaleX: CGFloat(1.0 + additionalScale), y: CGFloat(1.0 + additionalScale)) //Scale label area
        }
        CATransaction.commit()
    }
}

enum AnimationFactory {
    static func makeFade(duration: TimeInterval, delayFactor: Double) -> CustomAnimation {
        return { cell, indexPath, _ in
            cell.alpha = 0
            
            UIView.animate(
                withDuration: duration,
                delay: delayFactor * Double(indexPath.row),
                animations: {
                    cell.alpha = 1
            })
        }
    }
    
    static func makeMoveUpWithBounce(rowHeight: CGFloat, duration: TimeInterval, delayFactor: Double) -> CustomAnimation {
        return { cell, indexPath, tableView in
            cell.transform = CGAffineTransform(translationX: 0, y: rowHeight)
            
            UIView.animate(
                withDuration: duration,
                delay: delayFactor * Double(indexPath.row),
                usingSpringWithDamping: 0.4,
                initialSpringVelocity: 0.1,
                options: [.curveEaseInOut],
                animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        }
    }
    
    static func makeSlideIn(duration: TimeInterval, delayFactor: Double) -> CustomAnimation {
        return { cell, indexPath, tableView in
            cell.transform = CGAffineTransform(translationX: tableView.bounds.width, y: 0)
            
            UIView.animate(
                withDuration: duration,
                delay: delayFactor * Double(indexPath.row),
                options: [.curveEaseInOut],
                animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        }
    }
    
    static func makeMoveUpWithFade(rowHeight: CGFloat, duration: TimeInterval, delayFactor: Double) -> CustomAnimation {
        return { cell, indexPath, tableView in
            cell.transform = CGAffineTransform(translationX: 0, y: rowHeight / 2)
            cell.alpha = 0
            
            UIView.animate(
                withDuration: duration,
                delay: delayFactor * Double(indexPath.row),
                options: [.curveEaseInOut],
                animations: {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
                    cell.alpha = 1
            })
        }
    }
}
