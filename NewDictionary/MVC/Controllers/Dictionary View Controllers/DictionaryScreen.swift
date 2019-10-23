//
//  DictionaryScreen.swift
//  WordList
//
//  Created by Alexander Parshakov on 26/09/2019.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import UIKit
import CoreData
import Lottie

class DictionaryScreen: UIViewController {
    
    @IBOutlet weak var wordTableView: UITableView!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var searchBar: CustomSearchBar!
    
    
    @IBAction func didEndOnExit(_ sender: Any) {
        searchBar.resignFirstResponder()
    }
    
    var hasSearchStarted: Bool = false
    private let refreshControl = UIRefreshControl()
    private var timer: Timer?
    private var isSearchBarEmpty: Bool {
        guard let text = searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchBar.isEnabled && !isSearchBarEmpty
    }
    private var animationExists: Bool {
        return animationView != nil
    }
    
    private var wordList: Array<WordUnit>? = nil
    private var filteredList: Array<WordUnit>? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreen()
        setupTable()
        setupColors()
        setupRefreshControl()
        setupSearchController()
        loadWords()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if self.traitCollection.userInterfaceStyle == .dark {
//            searchBar.textColor = UIColor(named: Constants.ColorNames.fontColor)
//        } else {
//            searchBar.textColor = UIColor(named: Constants.ColorNames.fontColor)
//        }
        if animationExists {
            AnimationManager.startAnimation(animationView: animationView)
        }
    }
    func setupScreen() {
        self.title = Constants.Literals.Dictionary.mainTitle
    }
    func setupTable() {
        wordTableView.delegate = self
        wordTableView.dataSource = self
        wordTableView.isHidden = true
        searchBar.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    func setupColors() {
        searchBar.borderColor = Constants.Colors.deepRed
    }
    func setupRefreshControl() {
        AnimationManager.setTableRefreshControl(refreshControl: refreshControl, forTable: wordTableView)
        self.refreshControl.addTarget(self, action: #selector(refreshList), for: .valueChanged)
    }
    @objc func refreshList() {
        AnimationManager.startTableRefreshAnimation(refreshControl: refreshControl)
        loadWords()
    }
    func setupSearchController() {
        searchBar.placeholder = Constants.Literals.Dictionary.searchBarText
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWord" {
            if let indexPath = wordTableView.indexPathForSelectedRow {
                var word = WordUnit()
                if isFiltering {
                    word = (filteredList?[indexPath.row])!
                }
                else {
                    word = (wordList?[indexPath.row])!
                }
                let wordVC = segue.destination as! WordScreen
                wordVC.wordUnit = word
            }
        }
    }
    
}


// table
extension DictionaryScreen: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredList?.count ?? 0
        }
        return wordList?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentWord:WordUnit
        if isFiltering {
            currentWord = (filteredList?[indexPath.row])!
        }
        else {
            currentWord = (wordList?[indexPath.row])!
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Literals.Dictionary.dictionaryCell) as! DictionaryViewCell
        cell.setWord(word: currentWord)
        
        return cell
    }
}

// search bar
extension DictionaryScreen: UITextFieldDelegate {
    
    @objc func endEditing() {
        searchBar.resignFirstResponder()
    }
    @IBAction func didSearchEditingChanged(_ sender: Any) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.filterByContent(content: self.searchBar.text!)
        })
    }
     func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchBar.resignFirstResponder()
        searchBar.text!.removeAll()
        wordTableView.reloadData()
        return false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if searchBar.text?.count == 0 {
            return true
        }
        self.filterByContent(content: self.searchBar.text!)
        return true
    }
    
    func updateSearchResults(for searchBar: CustomSearchBar) {
        filterByContent(content: searchBar.text!)
    }
    func filterByContent(content: String) {
        filteredList = wordList?.filter({ (wu: WordUnit) -> Bool in
            return wu.content.lowercased().contains(content.lowercased())
                || wu.meaning.lowercased().contains(content.lowercased())
                || wu.example.lowercased().contains(content.lowercased())
                || wu.note.lowercased().contains(content.lowercased())
                || wu.isTagRelevant(content: content)
        })
        wordTableView.reloadData()
    }
}

// data manipulation
extension DictionaryScreen {
    func loadWords() {
        NetworkManager.WordUnits.getWords { [weak self] (result) in
            switch result {
                
                case .success(let words):
                    self?.wordList = words
                    self?.wordTableView.reloadData()
                    self?.wordTableView.isHidden = false
                    if let animation = self?.animationView {
                        animation.removeFromSuperview()
                    }
                    self?.refreshControl.endRefreshing()
                case .failure(let error):
                    print("Error: ", error)
            }
        }
    }
}
