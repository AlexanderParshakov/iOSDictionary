//
//  AddTagsScreen.swift
//  NewDictionary
//
//  Created by Alexander Parshakov on 11/7/19.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import UIKit
import Lottie

protocol AddTagsDelegate {
    func addTags(tags: [Tag])
}

class AddTagsScreen: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tagsTableView: UITableView!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBAction func onAddButtonTouched(_ sender: Any) {
        if searchBar.isFirstResponder {
            tagTableHeightConstraint.isActive = false
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                self.searchBar.resignFirstResponder()
                self.scrollToFirstRow()
            }
            searchBar.text?.removeAll()
            stackSelectedAbove(inTagArray: &self.tagList)
            tagsTableView.reloadData()
        }
        else {
            self.delegate?.addTags(tags: self.tagList.filter({ $0.isSelected == true }))
            dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func onCancelButtonTouched(_ sender: Any) {
        if searchBar.isFirstResponder {
            tagTableHeightConstraint.isActive = false
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                self.searchBar.resignFirstResponder()
                self.scrollToFirstRow()
            }
            searchBar.text?.removeAll()
            stackSelectedAbove(inTagArray: &self.tagList)
            tagsTableView.reloadData()
        }
        else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var addButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet var tagTableHeightConstraint: NSLayoutConstraint!
    var cancelButtonCenterXConstraint: NSLayoutConstraint!
    
    var delegate: AddTagsDelegate?
    var tagList: Array<Tag> = [Tag]()
    var filteredTagList: Array<Tag> = [Tag]()
    var tagsFromMain: Array<Tag> = [Tag]()
    var originalTableHeight: CGFloat = 0
    
    private var isFiltering: Bool {
        return !searchBar.text!.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defer {
            setupConforming()
            addObservers()
        }
        searchBar.placeholder = Constants.Localizables.Dictionary.tagsSearchBarPlaceholder
        LottieManager.curtainScreen(animationView: animationView, tableView: tagsTableView)
        loadTags()
        setupTagSelection()
        setupButtons()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addButtonHeightConstraint.constant = 40
        addButtonWidthConstraint.constant = view.frame.width * 0.4
        cancelButtonHeightConstraint.constant = 40
        cancelButtonWidthConstraint.constant = view.frame.width * 0.4
        
        tagTableHeightConstraint.isActive = false
        view.layoutIfNeeded()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.originalTableHeight = self.tagsTableView.frame.height
    }
    func setupConforming() {
        tagsTableView.delegate = self
        tagsTableView.dataSource = self
        searchBar.delegate = self
    }
    func setupButtons() {
        addButton.layer.cornerRadius = 10
        addButton.tintColor = .white
        addButton.isEnabled = false
        addButton.setTitleColor(Constants.Colors.darkGrey, for: .disabled)
        addButton.setTitleColor(UIColor.white, for: .normal)
        
        
        cancelButton.layer.cornerRadius = 10
    }
    func setupTagSelection() {
        tagsFromMain.forEach({ (tagFromMain) in
            tagList.first(where: { $0.id == tagFromMain.id })?.isSelected = true
        })
        stackSelectedAbove(inTagArray: &tagList)
        tagsTableView.reloadData()
    }
}


extension AddTagsScreen: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredTagList.count
        }
        return tagList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentTag:Tag
        if isFiltering {
            currentTag = (filteredTagList[indexPath.row])
        }
        else {
            currentTag = (tagList[indexPath.row])
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Localizables.Dictionary.addTagsCell) as! AddTagsCell
        cell.selectionStyle = .none
        cell.setTag(tag: currentTag)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tagsTableView.cellForRow(at: indexPath!) as! AddTagsCell
        
        if let row = tagList.firstIndex(where: {$0.id == currentCell.tagVariable?.id}) {
            let isSelected:Bool = (tagList[row].isSelected)
            tagList[row].isSelected = !isSelected
        }
        changeAddButtonEnabled()
        tagsTableView.reloadRows(at: [indexPath!], with: UITableView.RowAnimation.none)
    }
    func scrollToFirstRow() {
      let indexPath = IndexPath(row: 0, section: 0)
        if tagsTableView.numberOfRows(inSection: 0) != 0 {
            self.tagsTableView.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
    func changeAddButtonEnabled() {
        let initiallySelectedIds = tagsFromMain.map({ $0.id})
        let currentlySelectedIds = tagList
            .filter({ (tag: Tag) -> Bool in
                                    return tag.isSelected })
            .map({ $0.id })
        
        if initiallySelectedIds != currentlySelectedIds {
            addButton.isEnabled = true
        }
        else {
            addButton.isEnabled = false
        }
    }
}

// MARK: - Getting Data
extension AddTagsScreen {
    
    func loadTags() {
        tagList = RealmManager.Tags.retrieve()
        if (tagList.count > 0) {
            LottieManager.uncurtainScreen(animationView: animationView, tableView: tagsTableView)
        }
            
        else {
            NetworkManager.Tags.getAll { [weak self] (result) in
                switch result {
                    case .success(let tags):
                        self?.tagList = tags
                        self?.tagsTableView.reloadData()
                        guard let animation = self?.animationView else { return }
                        LottieManager.uncurtainScreen(animationView: animation, tableView: self?.tagsTableView)
                    case .failure(let error):
                        print("Error: ", error)
                }
            }
        }
    }
    func stackSelectedAbove(inTagArray array: inout [Tag]) {
        let selectedArray = array.filter({ $0.isSelected})
        array = selectedArray + array.filter({ !$0.isSelected})
    }
}

extension AddTagsScreen: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filter(content: searchText)
        if searchBar.text!.isEmpty {
            
            stackSelectedAbove(inTagArray: &self.tagList)
        }
        self.tagsTableView.reloadData()
        if tagsTableView.numberOfRows(inSection: 0) == 0 && cancelButtonCenterXConstraint.isActive == true {
            extendAddButton()
            addButton.isEnabled = true
        }
        else if tagsTableView.numberOfRows(inSection: 0) != 0 {
            shrinkAddButton()
        }
    }
    func filter(content: String) {
        let startingWith = tagList.filter({ $0.name.lowercased().hasPrefix(content.lowercased()) })
        let notStartingWithButContaining = tagList.filter({ !$0.name.lowercased().hasPrefix(content.lowercased())
            && $0.name.lowercased().contains(content.lowercased()) })
        filteredTagList = startingWith + notStartingWithButContaining
        tagsTableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        self.filter(content: searchBar.text!)
        self.tagsTableView.reloadData()
    }
}

// MARK: - Keyboard Moveup Handling
extension AddTagsScreen {
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if tagsTableView.frame.height == originalTableHeight {
                tagTableHeightConstraint.isActive = true
                tagTableHeightConstraint.constant = tagsTableView.frame.height - keyboardSize.height + 30
                cancelButton.setTitle("Done", for: .normal)
                addButton.setTitle("Create tag", for: .normal)
                cancelButton.titleLabel?.font = UIFont.init(name: Constants.Fonts.regularPalatino, size: 18)
                
                cancelButtonCenterXConstraint = cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
                shrinkAddButton()
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        tagTableHeightConstraint.isActive = false
        extendAddButton()
        cancelButton.setTitle("Cancel", for: .normal)
        addButton.setTitle("Ready", for: .normal)
    }
    func shrinkAddButton() {
        cancelButtonCenterXConstraint.isActive = true
        addButtonWidthConstraint.constant = 0
        addButton.clipsToBounds = true
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    func extendAddButton() {
        cancelButtonCenterXConstraint.isActive = false
        cancelButtonWidthConstraint.constant = view.frame.width * 0.4
        addButtonWidthConstraint.constant = view.frame.width * 0.4
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}
