//
//  WordScreen.swift
//  WordList
//
//  Created by Alexander Parshakov on 26/09/2019.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import UIKit
import TagListView

class WordScreen: UIViewController {
    
    var wordUnit = WordUnit()

    @IBOutlet weak private var contentLabel: UILabel!
    @IBOutlet weak var meaningLabel: UILabel!
    @IBOutlet weak var exampleLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.tintColor = Constants.Colors.deepRed;
        setLabels()
        setTags()
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 100)
    }
    override func viewDidLayoutSubviews() {
        scrollView.layoutIfNeeded()
        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: contentView.frame.size.height + 20)
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
