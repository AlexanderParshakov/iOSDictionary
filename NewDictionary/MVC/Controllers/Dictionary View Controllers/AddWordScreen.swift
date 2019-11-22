//
//  AddWordScreenViewController.swift
//  NewDictionary
//
//  Created by Alexander Parshakov on 11/5/19.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import UIKit
import TagListView

class AddWordScreen: UIViewController {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var exampleLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    
    @IBOutlet weak var contentTextView: InputField!
    @IBOutlet weak var meaningTextView: InputField!
    @IBOutlet weak var exampleTextView: InputField!
    @IBOutlet weak var noteTextView: InputField!
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var addTagButton: UIButton!
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var languageView: UIView!
    
    @IBOutlet weak var sourceView: UIView!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    
    @IBAction func onAddTagTapped(_ sender: Any) {
        
    }
    @IBAction func onDetailsButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.9) {
            self.detailsButton.backgroundColor = .systemRed
            self.detailsButton.backgroundColor = UIColor(named: "FormColor")
        }
        switchDetailsVisibility()
    }
    
    
    var contentPlaceholderLabel: UILabel! = UILabel()
    var meaningPlaceholderLabel: UILabel! = UILabel()
    var examplePlaceholderLabel: UILabel! = UILabel()
    var notePlaceholderLabel: UILabel! = UILabel()
    var activeTextView: UITextView! = UITextView()
    var tagList:[Tag] = [Tag]()
    var detailsIconName = "chevron.up"
    var timer: Timer = Timer()
    
    
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var meaningHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var exampleHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var noteHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tagListViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var exampleLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var noteLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tagsLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addTagsButtonHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var termLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var exampleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var exampleTextViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var noteLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var noteTextViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tagsLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var tagListTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var addTagButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var addTagButtonBottomConstraint: NSLayoutConstraint!
    
    
    
    let contentKey = "Content"
    let meaningKey = "Meaning"
    let exampleKey = "Example"
    let noteKey = "Note"
    var textViewDictionary: Dictionary<String, (UITextView, UILabel, NSLayoutConstraint)> = Dictionary()
    var selectedLangId: Int = 2
    var waitingForLangSelection: Bool = false
    var selectedSourceId: Int = 40
    var waitingForSourceSelection: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 100)
        scrollView.showsVerticalScrollIndicator = false
        
        detailsButton.layer.cornerRadius = 10
        detailsView.layer.cornerRadius = 10
        
        initTextViews()
        setupTagListView()
        setupLanguageView()
        setupSourceView()
        setupAddTagButton()
        setupTapRecognizers()
        switchDetailsVisibility(animated: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (waitingForLangSelection)
        {
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: { (_) in
                Animator.animateLabelColor(firstColor: .systemRed, secondColor: UIColor(named: "FontColor")!, label: self.languageLabel)
            })
            waitingForLangSelection = false
        }
        if (waitingForSourceSelection)
        {
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: { (_) in
                Animator.animateLabelColor(firstColor: .systemRed, secondColor: UIColor(named: "FontColor")!, label: self.sourceLabel)
            })
            waitingForSourceSelection = false
        }
    }
    func setupTagListView() {
        tagListView.textFont = UIFont(name: Constants.Fonts.boldPalatino, size: 16)!
        tagListViewHeightConstraint.constant = 0
        tagListView.delegate = self
    }
    func setupLanguageView() {
        languageView.layer.cornerRadius = 15
    }
    func setupSourceView() {
        sourceView.layer.cornerRadius = 15
    }
    func setupAddTagButton() {
        addTagButton.layer.cornerRadius = 10
    }
    func setupTapRecognizers() {
        let tapOnView = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapOnView)
//
//        let tapOnSourceView = UITapGestureRecognizer(target: self, action: #selector(goForLanguageSelection))
//        sourceView.addGestureRecognizer(tapOnSourceView)
    }
    @objc func dismissKeyboard() {
        activeTextView.resignFirstResponder()
    }
    @objc func goForSourceSelection() {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTagsModally" {
            let destination = segue.destination as! AddTagsScreen
            destination.delegate = self
            destination.tagsFromMain = tagList
        }
        if segue.identifier == "showSelectLanguage" {
            let destination = segue.destination as! SelectLanguageScreen
            destination.delegate = self
            destination.selectedLangId = selectedLangId
            
            waitingForLangSelection = true
        }
        if segue.identifier == "showSelectSource" {
            let destination = segue.destination as! SelectSourceScreen
            destination.delegate = self
            destination.selectedSourceId = selectedSourceId
            
            waitingForSourceSelection = true
        }
    }
    
}

extension AddWordScreen: AddTagsDelegate, TagListViewDelegate {
    func addTags(tags: [Tag]) {
        self.tagList = tags
        self.refreshTags(tags: self.tagList)
    }
    func refreshTags(tags: [Tag]) {
        self.tagListView.removeAllTags()
        tags.forEach { (tag) in
            self.tagListView.addTag(tag.name)
        }
    }
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        
    }
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        tagList = tagList.filter { $0.name != title }
        tagListView.removeTag(title)
        self.view.layoutIfNeeded()
    }
}

extension AddWordScreen: SelectLanguageDelegate, SelectSourceDelegate {
    func selectLanguage(selectedLang: Language) {
        self.languageLabel.text = selectedLang.name + " (\(selectedLang.location))"
        self.selectedLangId = selectedLang.id
    }
    func selectSource(selectedSource: Source) {
        self.sourceLabel.text = selectedSource.name
        self.selectedSourceId = selectedSource.id
    }
}

extension AddWordScreen: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        activeTextView = textView
    }
    
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
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView == exampleTextView {
            UIView.transition(with: textView,
                              duration: 0.4,
                             options: [.transitionCrossDissolve],
                             animations: {
                                textView.text.removeSideQuotes()
            }, completion: nil)
        }
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == exampleTextView {
            UIView.transition(with: textView,
                              duration: 0.4,
                              options: [.transitionCrossDissolve],
                              animations: {
                                textView.text.addSideQuotes()
                                self.textViewDidChange(textView)
            }, completion: nil)
        }
    }
    
    func initTextViews() {
        textViewDictionary = [
            contentKey: (contentTextView, contentPlaceholderLabel, contentHeightConstraint),
            meaningKey: (meaningTextView, meaningPlaceholderLabel, meaningHeightConstraint),
            exampleKey: (exampleTextView, examplePlaceholderLabel, exampleHeightConstraint),
            noteKey: (noteTextView, notePlaceholderLabel, noteHeightConstraint)
        ]
        
        for (key, (textView, label, _)) in textViewDictionary {
            switch key {
//                case contentKey:
//                    label.text = Constants.Localizables.Dictionary.contentPlaceholder
//                case meaningKey:
//                    label.text = Constants.Localizables.Dictionary.meaningPlaceholder
//                case exampleKey:
//                    label.text = Constants.Localizables.Dictionary.examplePlaceholder
//                case noteKey:
//                    label.text = Constants.Localizables.Dictionary.notePlaceholder
                default:
                    print("Found no label with given names.")
            }
            setLabelsAndTextViews(textView: textView, label: label)
        }
    }
    func setLabelsAndTextViews(textView: UITextView, label: UILabel) {
        label.font = UIFont.systemFont(ofSize: ((textView.font as AnyObject).pointSize)!)
        label.sizeToFit()
        label.frame.origin = CGPoint(x: 15, y: ((textView.font as AnyObject).pointSize)! / 2 + 3)
        label.isHidden = !textView.text.isEmpty
        textView.addSubview(label)
        
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
        textView.layer.cornerRadius = 10
    }
}


// MARK: - Details View Manipulation
extension AddWordScreen {
    func switchDetailsVisibility(animated: Bool = true) {
        switchDetailsTopAndBottomConstraints()
        switchHeightConstraints()
        
        detailsIconName = (detailsIconName == "chevron.up" ? "chevron.down" : "chevron.up")
        detailsButton.setImage(UIImage (systemName: detailsIconName), for: .normal)
        
        if animated {
            UIView.animate(withDuration: 0.6) {
                self.detailsViewHeightConstraint.constant = (self.detailsViewHeightConstraint.constant == 0 ? 400 : 0)
                self.view.layoutIfNeeded()
            }
        }
        else {
            self.detailsViewHeightConstraint.constant = (self.detailsViewHeightConstraint.constant == 0 ? 400 : 0)
            self.view.layoutIfNeeded()
        }
    }
    func switchHeightConstraints() {
        let labelHeight = CGFloat(integerLiteral: 23)
        let textViewHeight = CGFloat(integerLiteral: 40)
        
        noteLabelHeightConstraint.constant = (noteLabelHeightConstraint.constant == 0 ? labelHeight : 0)
        noteHeightConstraint.constant = (noteHeightConstraint.constant == 0 ? textViewHeight : 0)
        if noteHeightConstraint.constant != 0 {
            textViewDidChange(noteTextView)
        }
        
        exampleLabelHeightConstraint.constant = (exampleLabelHeightConstraint.constant == 0 ? labelHeight : 0)
        exampleHeightConstraint.constant = (exampleHeightConstraint.constant == 0 ? textViewHeight : 0)
        if exampleHeightConstraint.constant != 0 {
            textViewDidChange(exampleTextView)
        }
        
        tagsLabelHeightConstraint.constant = (tagsLabelHeightConstraint.constant == 0 ? labelHeight : 0)
        addTagsButtonHeightConstraint.constant = (addTagsButtonHeightConstraint.constant == 0 ? 40 : 0)
        addTagButton.clipsToBounds = true
        if addTagsButtonHeightConstraint.constant == 0 {
            tagListView.removeAllTags()
        }
        else {
            if tagListView.tagViews.count == 0 && tagList.count != 0 {
                tagList.forEach { (tag) in
                    tagListView.addTag(tag.name)
                }
            }
        }
    }
    func switchDetailsTopAndBottomConstraints() {
        let labelTopConstraint = 10
        let textViewTopConstraint = 5
        
        termLabelTopConstraint.constant = (termLabelTopConstraint.constant == view.frame.height/3.5 ? 20 : view.frame.height/3.5)
        exampleLabelTopConstraint.constant = CGFloat((exampleLabelTopConstraint.constant == 0 ? labelTopConstraint : 0))
        exampleTextViewTopConstraint.constant = CGFloat((exampleTextViewTopConstraint.constant == 0 ? textViewTopConstraint : 0))
        noteLabelTopConstraint.constant = CGFloat((noteLabelTopConstraint.constant == 0 ? labelTopConstraint : 0))
        noteTextViewTopConstraint.constant = CGFloat((noteTextViewTopConstraint.constant == 0 ? textViewTopConstraint : 0))
        tagsLabelTopConstraint.constant = CGFloat((tagsLabelTopConstraint.constant == 0 ? labelTopConstraint : 0))
        tagListTopConstraint.constant = CGFloat((tagListTopConstraint.constant == 0 ? textViewTopConstraint : 0))
        addTagButtonTopConstraint.constant = CGFloat((addTagButtonTopConstraint.constant == 0 ? labelTopConstraint : 0))
        addTagButtonBottomConstraint.constant = CGFloat((addTagButtonBottomConstraint.constant == 0 ? labelTopConstraint : 0))
    }
}
