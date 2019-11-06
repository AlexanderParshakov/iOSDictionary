//
//  AddWordScreenViewController.swift
//  NewDictionary
//
//  Created by Alexander Parshakov on 11/5/19.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import UIKit

class AddWordScreen: UIViewController {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var meaningTextView: UITextView!
    @IBOutlet weak var exampleTextView: UITextView!
    @IBOutlet weak var noteTextView: UITextView!
    
    var contentPlaceholderLabel: UILabel! = UILabel()
    var meaningPlaceholderLabel: UILabel! = UILabel()
    var examplePlaceholderLabel: UILabel! = UILabel()
    var notePlaceholderLabel: UILabel! = UILabel()
    
    
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var meaningHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var exampleHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var noteHeightConstraint: NSLayoutConstraint!
    
    
    let contentKey = "Content"
    let meaningKey = "Meaning"
    let exampleKey = "Example"
    let noteKey = "Note"
    var textViewDictionary: Dictionary<String, (UITextView, UILabel, NSLayoutConstraint)> = Dictionary()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 100)
        
        setupTextViews()
    }
    
    func setupTextViews() {
        textViewDictionary = [
            contentKey: (contentTextView, contentPlaceholderLabel, contentHeightConstraint),
            meaningKey: (meaningTextView, meaningPlaceholderLabel, meaningHeightConstraint),
            exampleKey: (exampleTextView, examplePlaceholderLabel, exampleHeightConstraint),
            noteKey: (noteTextView, notePlaceholderLabel, noteHeightConstraint)
        ]
        
        for (key, (textView, label, _)) in textViewDictionary {
            switch key {
                case contentKey:
                    label.text = Constants.Localizables.Dictionary.contentPlaceholder
                case meaningKey:
                    label.text = Constants.Localizables.Dictionary.meaningPlaceholder
                case exampleKey:
                    label.text = Constants.Localizables.Dictionary.examplePlaceholder
                case noteKey:
                    label.text = Constants.Localizables.Dictionary.notePlaceholder
                default:
                    print("Found no label with given names.")
            }
            
            label.font = UIFont.systemFont(ofSize: ((textView.font as AnyObject).pointSize)!)
            label.sizeToFit()
            label.frame.origin = CGPoint(x: 15, y: ((textView.font as AnyObject).pointSize)! / 2 + 3)
            label.textColor = UIColor.lightGray
            label.isHidden = !textView.text.isEmpty
            
            textView.addSubview(label)
            textView.delegate = self
            textView.isScrollEnabled = false
            textView.textColor = UIColor.lightGray
            textView.backgroundColor = Constants.Colors.darkGrey
            textView.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
            textView.layer.cornerRadius = 10
        }
    }
}


extension AddWordScreen: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        for (_, (dicTextView, label, heightConstraint)) in textViewDictionary {
            if dicTextView == textView {
                heightConstraint.constant = estimatedSize.height
                label.isHidden = !textView.text.isEmpty
            }
        }
    }
    
}
