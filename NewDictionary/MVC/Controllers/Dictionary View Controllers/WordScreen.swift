//
//  WordScreen.swift
//  WordList
//
//  Created by Alexander Parshakov on 26/09/2019.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import UIKit
import TagListView
import Hero

class WordScreen: UIViewController {
    
    var wordUnit = WordUnit()
    
    @IBOutlet weak private var contentLabel: UILabel!
    @IBOutlet weak var meaningLabel: UILabel!
    @IBOutlet weak var exampleLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var wrapperView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLabels()
        setTags()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        setupWrapperView()
        wrapperView.hero.id = "word" + String(wordUnit.id)
        contentLabel.hero.id = "contentLabel" + String(wordUnit.id)
        meaningLabel.hero.id = "meaningLabel" + String(wordUnit.id)
    }
    override func viewDidLayoutSubviews() {
        scrollView.layoutIfNeeded()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: contentView.frame.size.height + 20)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    func setLabels() {
        contentLabel.text = wordUnit.content
        meaningLabel.text = wordUnit.meaning
        exampleLabel.text = wordUnit.example
        noteLabel.text = wordUnit.note
    }
    func setTags() {
        tagListView.textFont = UIFont.systemFont(ofSize: 20, weight: .semibold)
        tagListView.textFont = UIFont(name: Constants.Fonts.boldPalatino, size: 19)!
        
        for tag in wordUnit.tags {
            tagListView.addTag(tag.name)
        }
    }
    func setupWrapperView() {
//        view.backgroundColor = .clear
        wrapperView.layer.cornerRadius = 15
        wrapperView.setSlightShadow(shadowColor: .systemGray)
    }
    func loadWord() {
        NetworkManager.WordUnits.getById(wordId: wordUnit.id) { [weak self] (result) in
            switch result {
                
                case .success(let wordUnit):
                    self?.contentLabel.text = wordUnit.content
                    self?.meaningLabel.text = wordUnit.meaning
                    self?.exampleLabel.text = wordUnit.example
                    self?.noteLabel.text = wordUnit.note
                case .failure(let error):
                    print("Error: ", error)
            }
        }
    }
}

// MARK: - Swipe Gestures
extension WordScreen {
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                case UISwipeGestureRecognizer.Direction.right:
                    self.navigationController?.popViewController(animated: true)
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                default:
                    break
            }
        }
    }
}
