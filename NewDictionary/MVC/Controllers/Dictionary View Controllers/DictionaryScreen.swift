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
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    var hasSearchStarted: Bool = false
    private let refreshControl = UIRefreshControl()
    private var timer: Timer?
    private var isSearchBarEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    private var animationExists: Bool {
        return animationView != nil
    }
    
    private var wordList: Array<WordUnit>? = nil
    private var filteredList: Array<WordUnit>? = nil
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreen()
        setupTable()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClick))
        setupColors()
        setupRefreshControl()
        setupSearchController()
        loadWords()
    }
    func setupScreen() {
        self.title = Constants.Localizables.Dictionary.mainTitle
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    func setupTable() {
        wordTableView.delegate = self
        wordTableView.dataSource = self
    }
    func setupColors() {
        self.navigationController!.navigationBar.tintColor = Constants.Colors.deepRed
    }
    func setupRefreshControl() {
        AnimationManager.setTableRefreshControl(refreshControl: refreshControl, forTable: wordTableView)
        self.refreshControl.addTarget(self, action: #selector(refreshList), for: .valueChanged)
    }
    @objc func refreshList() {
        AnimationManager.startTableRefreshAnimation(refreshControl: refreshControl)
        loadWords(refreshing: true)
    }
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false 
        searchController.searchBar.placeholder = Constants.Localizables.Dictionary.searchBarText
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    @objc func addButtonClick(){
        self.performSegue(withIdentifier: "AddWord", sender: nil)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Localizables.Dictionary.dictionaryCell) as! DictionaryViewCell
        cell.setWord(word: currentWord)
        
        return cell
    }
}

// search bar
extension DictionaryScreen: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.filterByContent(content: self.searchController.searchBar.text!)
        })
    }
    func filterByContent(content: String) {
        filteredList = wordList?.filter({ (wu: WordUnit) -> Bool in
            return wu.content.lowercased().contains(content.lowercased())
                || wu.isTagRelevant(content: content)
                || wu.meaning.lowercased().contains(content.lowercased())
                || wu.example.lowercased().contains(content.lowercased())
                || wu.note.lowercased().contains(content.lowercased())
        })
        wordTableView.reloadData()
    }
}

// MARK: - Data Loading
extension DictionaryScreen {
    
    func loadWords(refreshing: Bool = false) {
        wordList = RealmManager.WordUnits.retrieve()
        if wordList?.count ?? 0 > 0 && !refreshing {
            AnimationManager.uncurtainScreen(animationView: animationView, tableView: wordTableView)
        }
        else if wordList?.count ?? 0 == 0 || refreshing {
            NetworkManager.WordUnits.getWords { [weak self] (result) in
                switch result {
                    case .success(let words):
                        self?.wordList = words
                        self?.wordTableView.reloadData()
                        if self!.animationExists {
                            AnimationManager.uncurtainScreen(animationView: self!.animationView, tableView: self?.wordTableView)
                        }
                        self?.refreshControl.endRefreshing()
                    case .failure(let error):
                        print("Error: ", error)
                }
            }
        }
    }
}
