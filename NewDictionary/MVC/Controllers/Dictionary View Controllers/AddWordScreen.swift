//
//  AddWordScreenViewController.swift
//  NewDictionary
//
//  Created by Alexander Parshakov on 11/5/19.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import UIKit
import TagListView
import IQKeyboardManager
import Hero

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
    //    @IBOutlet weak var typesTableView: UITableView!
    @IBOutlet weak var addTermButton: UIButton!
    
    @IBAction func onAddTagTapped(_ sender: Any) {
    }
    @IBAction func onDetailsButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.9) {
//            self.detailsView.backgroundColor = .systemRed
            self.detailsView.backgroundColor = UIColor(named: "FormColor")
        }
        switchDetailsViewVisibility()
        if tagListTopConstraint.constant != 0 {
            UIView.animate(withDuration: animationDuration) {
                let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
                self.scrollView.setContentOffset(bottomOffset, animated: false)
            }
        }
        else {
            scrollView.setContentOffset(CGPoint(x: 0, y: 10), animated: true)
        }
    }
    
    
    var contentPlaceholderLabel: UILabel! = UILabel()
    var meaningPlaceholderLabel: UILabel! = UILabel()
    var examplePlaceholderLabel: UILabel! = UILabel()
    var notePlaceholderLabel: UILabel! = UILabel()
    var activeTextView: UITextView! = UITextView()
    var tagList:[Tag] = [Tag]()
    var detailsIconName = "chevron.up"
    var defaultDetailsButtonYPosition: CGFloat = 0
    var animationDuration = 0.4
    var timer: Timer = Timer()
//    var typeList: [TermType] = [TermType]()
    var selectedTypesList: [TermType] = [TermType]()
    
    var delegate: AddWordScreenDelegate?
    
    
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
    
    
    
    
    let contentKey = "Content"
    let meaningKey = "Meaning"
    let exampleKey = "Example"
    let noteKey = "Note"
    var textViewDictionary: Dictionary<String, (InputField, UILabel, NSLayoutConstraint)> = Dictionary()
    var selectedLang: Language?
    var waitingForLangSelection: Bool = false
    var selectedSource: Source?
    var waitingForSourceSelection: Bool = false
    var firstLaunch: Bool = true
    var obligsReady:  Bool {
        return contentTextView.text != ""
            && selectedSource != nil
            && selectedLang != nil
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchDataFromDefaults()
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 70)
        scrollView.showsVerticalScrollIndicator = false
        
        detailsButton.layer.cornerRadius = 10
        detailsView.layer.cornerRadius = 10
        
        initTextViews()
        setupTagListView()
        setupLanguageView()
        setupSourceView()
        setupAddTagButton()
        setupTapRecognizers()
        setupDetailsView()
        switchDetailsViewVisibility(animated: false)
        
        defaultDetailsButtonYPosition = detailsView.frame.origin.y
        self.hero.isEnabled = true
        
        NavigationManager.setupAddButton(viewController: self)
        
        IQKeyboardManager.shared().toolbarDoneBarButtonItemText = "Hide"
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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    func fetchDataFromDefaults() {
        selectedLang = UserDefaultsManager.retrieveData(objectType: Language.self, key: Constants.UserDefaultKeys.lastSelectedLanguage) as? Language
        if let lang = selectedLang {
            self.languageLabel.text = lang.name + " (\(lang.location))"
        }
        
        selectedSource = UserDefaultsManager.retrieveData(objectType: Source.self, key: Constants.UserDefaultKeys.lastSelectedSource) as? Source
        if let source = selectedSource {
            self.sourceLabel.text = source.name
        }
        
    }
    func setupTagListView() {
        tagListView.textFont = UIFont(name: Constants.Fonts.boldPalatino, size: 16)!
        tagListViewHeightConstraint.constant = 0
        tagListView.delegate = self
        tagListView.removeAllTags()
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
        tapOnView.cancelsTouchesInView = false
        view.addGestureRecognizer(tapOnView)
    }
    func setupDetailsView() {
        var viewList = [UIView]()
        viewList.append(detailsView)
        viewList.append(sourceView)
        viewList.append(languageView)
        
        viewList.forEach { (customView) in
            customView.layer.masksToBounds = false
            customView.layer.shadowColor = UIColor.systemGray .cgColor
            customView.layer.shadowOffset = CGSize(width: 2, height:  2)
            customView.layer.shadowRadius = 10
            customView.layer.shadowOpacity = 0.25
            self.view.bringSubviewToFront(customView)
        }
    }
    @objc func dismissKeyboard() {
        activeTextView.resignFirstResponder()
    }
    @objc func onAddTapped() {
        var term = WordUnit()
        term.content = contentTextView.text
        term.content.firstLetterToLowerCase()
        term.meaning = meaningTextView.text
        term.meaning.firstLetterToLowerCase()
        term.example = exampleTextView.text
        term.note = noteTextView.text
        guard let source = selectedSource else { return }
        guard let lang = selectedLang else { return }
        term.source = source
        term.lang = lang
        
        term.tags = tagList
        NetworkManager.WordUnits.postTerm(term: term)
        
        navigationController?.popViewController(animated: true)
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
            if let lang = selectedLang {
                destination.selectedLang = lang
            }
            
            waitingForLangSelection = true
        }
        if segue.identifier == "showSelectSource" {
            let destination = segue.destination as! SelectSourceScreen
            destination.delegate = self
            if let source = selectedSource {
                destination.selectedSource = source
            }
            
            waitingForSourceSelection = true
        }
    }
    
}

extension AddWordScreen: AddTagsDelegate, TagListViewDelegate {
    func modalDidDisappear() {
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
    }
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
        self.selectedLang = selectedLang
        switchAddButtonEnabled()
        
        UserDefaultsManager.persistData(object: selectedLang, key: Constants.UserDefaultKeys.lastSelectedLanguage)
    }
    func selectSource(selectedSource: Source) {
        self.sourceLabel.text = selectedSource.name
        self.selectedSource = selectedSource
        switchAddButtonEnabled()
        
        UserDefaultsManager.persistData(object: selectedSource, key: Constants.UserDefaultKeys.lastSelectedSource)
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
            if dicTextView == contentTextView {
                title = contentTextView.text
                switchAddButtonEnabled()
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
            setLabelsAndTextViews(textView: textView, label: label)
        }
    }
    func setLabelsAndTextViews(textView: UITextView, label: UILabel) {
        label.font = UIFont.systemFont(ofSize: ((textView.font as AnyObject).pointSize)!)
        label.sizeToFit()
        label.frame.origin = CGPoint(x: 15, y: ((textView.font as AnyObject).pointSize)! / 2 + 3)
        label.isHidden = !textView.text.isEmpty
        label.textColor = .secondaryLabel
        textView.addSubview(label)
        
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
        textView.layer.cornerRadius = 10
    }
}


// MARK: - Details View Manipulation
extension AddWordScreen {
    func switchDetailsTopAndBottomConstraints() {
        let labelTopConstraint = 20
        let textViewTopConstraint = 5
        
        termLabelTopConstraint.constant = (termLabelTopConstraint.constant == 20 ? 50 : 20)
        exampleTextViewTopConstraint.constant = CGFloat((exampleTextViewTopConstraint.constant == 0 ? textViewTopConstraint : 0))
        exampleLabelTopConstraint.constant = CGFloat((exampleLabelTopConstraint.constant == 0 ? labelTopConstraint : 0))
        exampleTextViewTopConstraint.constant = CGFloat((exampleTextViewTopConstraint.constant == 0 ? textViewTopConstraint : 0))
        noteLabelTopConstraint.constant = CGFloat((noteLabelTopConstraint.constant == 0 ? labelTopConstraint : 0))
        noteTextViewTopConstraint.constant = CGFloat((noteTextViewTopConstraint.constant == 0 ? textViewTopConstraint : 0))
        tagsLabelTopConstraint.constant = CGFloat((tagsLabelTopConstraint.constant == 0 ? labelTopConstraint : 0))
        tagListTopConstraint.constant = CGFloat((tagListTopConstraint.constant == 0 ? textViewTopConstraint : 0))
        addTagButtonTopConstraint.constant = CGFloat((addTagButtonTopConstraint.constant == 0 ? labelTopConstraint : 0))
        
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
        addTagsButtonHeightConstraint.constant = (addTagsButtonHeightConstraint.constant == 0 ? 45 : 0)
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
    func switchDetailsViewVisibility(animated: Bool = true) {
        switchDetailsTopAndBottomConstraints()
        switchHeightConstraints()
        
        detailsIconName = (detailsIconName == "chevron.up" ? "chevron.down" : "chevron.up")
        detailsButton.setImage(UIImage (systemName: detailsIconName), for: .normal)
        
        if animated {
            UIView.animate(withDuration: animationDuration, animations: {
                self.detailsViewHeightConstraint.constant = (self.detailsViewHeightConstraint.constant == 0 ? 400 : 0)
                self.view.layoutIfNeeded()
            }) { (_) in
                UIView.animate(withDuration: self.animationDuration) {
                    self.switchDetailsVisibility()
                }
            }
        }
        else {
            self.detailsViewHeightConstraint.constant = (self.detailsViewHeightConstraint.constant == 0 ? 400 : 0)
            self.view.layoutIfNeeded()
        }
    }
    func switchDetailsVisibility() {
            self.exampleTextView.alpha = (self.exampleTextView.alpha == 0 ? 1 : 0)
            self.exampleLabel.alpha = (self.exampleLabel.alpha == 0 ? 1 : 0)
            self.noteLabel.alpha = (self.noteLabel.alpha == 0 ? 1 : 0)
            self.noteTextView.alpha = (self.noteTextView.alpha == 0 ? 1 : 0)
            self.tagsLabel.alpha = (self.tagsLabel.alpha == 0 ? 1 : 0)
            self.tagListView.alpha = (self.tagListView.alpha == 0 ? 1 : 0)
            self.addTagButton.alpha = (self.addTagButton.alpha == 0 ? 1 : 0)
    }
}


// MARK: - Changing State of Add Button
extension AddWordScreen {
    func switchAddButtonEnabled() {
        if obligsReady {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
        else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
}
