//
//  DictionaryScreen.swift
//  WordList
//
//  Created by Alexander Parshakov on 26/09/2019.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import UIKit
import Lottie
import Hero

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
    private var allRowsAnimated = false
    
    private var wordList: Array<WordUnit>? = nil
    private var filteredList: Array<WordUnit>? = nil
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hero.isEnabled = true
        
        LottieManager.curtainScreen(animationView: animationView, tableView: wordTableView)
        
        setupNavigation()
        setupTable()
        setupSearchController()
        setupRefreshControl()
        
        loadWords()
        
        
        setInitialValues()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NavigationManager.setupAddButton(viewController: self)
        self.navigationController?.view.subviews.forEach({ (view) in
            if view is UIButton && view.tag == Constants.Tags.AddTermButtonTag {
                (view as! UIButton).addTarget(self, action: #selector(addButtonClick), for: .touchUpInside)
            }
        })
    }
    func setupNavigation() {
        self.title = Constants.Localizables.Dictionary.mainTitle
        self.navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClick))
        self.navigationController?.isHeroEnabled = true
    }
    func setupTable() {
        wordTableView.delegate = self
        wordTableView.dataSource = self
        wordTableView.backgroundColor = .clear
    }
    func setupRefreshControl() {
        LottieManager.setTableRefreshControl(refreshControl: refreshControl, forTable: wordTableView)
        self.refreshControl.addTarget(self, action: #selector(refreshList), for: .valueChanged)
    }
    @objc func refreshList() {
        LottieManager.startTableRefreshAnimation(refreshControl: refreshControl)
        loadWords(refreshing: true)
    }
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false 
        searchController.searchBar.placeholder = Constants.Localizables.Dictionary.wordsSearchBarPlaceholder
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        self.navigationController!.navigationBar.tintColor = .systemRed
    }
    @objc func addButtonClick(){
        self.performSegue(withIdentifier: "AddWord", sender: nil)
    }
    func setInitialValues() {
        wordList = wordList?.sorted(by: {$0.id > $1.id})
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
        else if segue.identifier == "AddWord" {
            navigationController?.isHeroEnabled = true
            Hero.shared.defaultAnimation = .zoom
            NetworkManager.addWordDelegate = self
        }
    }
}


// table
extension DictionaryScreen: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !allRowsAnimated {
            let animation = AnimationFactory.makeMoveUpWithFade(rowHeight: cell.frame.height, duration: 0.45, delayFactor: 0.25)
            let animator = Animator(animation: animation)
            animator.animate(cell: cell, at: indexPath, in: tableView)
            if tableView.isLastVisibleCell(at: indexPath) {
                allRowsAnimated = true
            }
        }
    }
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
        cell.customBackgroundView.hero.id = "word" + String(currentWord.id)
        cell.contentLabel.hero.id = "contentLabel" + String(currentWord.id)
        cell.meaningLabel.hero.id = "meaningLabel" + String(currentWord.id)
        return cell
    }
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            
            let editImage = UIImage(named: "Edit")?.withRenderingMode(.alwaysTemplate)
            let editAction = UIAction(title: "Edit", image: editImage) { _ in
                self.goToEdit()
            }
            
            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: [.destructive]) { _ in
                self.delete()
            }
         
            let menu = UIMenu(title: "", image: nil, identifier: nil, options: [], children: [editAction, deleteAction])
            
            return menu
        }
        
        return config
    }
    func goToEdit() {
        
    }
    func delete() {
        
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
            LottieManager.uncurtainScreen(animationView: animationView, tableView: wordTableView)
        }
        else if wordList?.count ?? 0 == 0 || refreshing {
            NetworkManager.WordUnits.getWords { [weak self] (result) in
                switch result {
                    case .success(let words):
                        self?.wordList = words
                        self?.wordTableView.reloadData()
                        if self!.animationExists {
                            LottieManager.uncurtainScreen(animationView: self!.animationView, tableView: self?.wordTableView)
                        }
                        self?.refreshControl.endRefreshing()
                    case .failure(let error):
                        print("Error: ", error)
                }
            }
        }
    }
}


extension DictionaryScreen: AddWordScreenDelegate {
    func termWasAdded(term: WordUnit) {
        wordList?.insert(term, at: 0)
//        wordList = wordList?.sorted(by: {$0.id > $1.id})
        wordTableView.reloadData()
    }
}
