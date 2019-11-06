//
//  SourceScreen.swift
//  WordList
//
//  Created by Alexander Parshakov on 28/09/2019.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import UIKit
import Lottie

class SourcesScreen: UIViewController {
    
    @IBOutlet weak var sourcesTableView: UITableView!
    @IBOutlet weak var animationView: AnimationView!
    
    
    private var sourceList: Array<Source>? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RealmManager.printPath()
        AnimationManager.curtainScreen(animationView: animationView, tableView: sourcesTableView)
        setupScreen()
        loadSources()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = Constants.Localizables.Sources.mainTitle
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        self.navigationItem.title = " "
    }
    func setupScreen() {
        self.title = Constants.Localizables.Sources.mainTitle
        sourcesTableView.delegate = self
        sourcesTableView.dataSource = self
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSource" {
            if let indexPath = sourcesTableView.indexPathForSelectedRow {
                var source = Source()
                source = (sourceList?[indexPath.row])!
                let sourceVC = segue.destination as! SourceScreen
                sourceVC.source = source
            }
        }
    }
    
}

// MARK: - Data Loading
extension SourcesScreen {
    
    func loadSources() {
        sourceList = RealmManager.Sources.retrieve()
        if (sourceList?.count ?? 0 > 0) {
            AnimationManager.uncurtainScreen(animationView: animationView, tableView: sourcesTableView)
        }
            
        else {
            NetworkManager.Sources.getAll { [weak self] (result) in
                switch result {
                    case .success(let sources):
                        self?.sourceList = sources
                        self?.sourcesTableView.reloadData()
                        guard let animation = self?.animationView else { return }
                        AnimationManager.uncurtainScreen(animationView: animation, tableView: self?.sourcesTableView)
                    case .failure(let error):
                        print("Error: ", error)
                }
            }
        }
    }
}


extension SourcesScreen: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sourceList?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let source = (sourceList?[indexPath.row])!
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Localizables.Sources.sourceCell) as! SourcesViewCell
        cell.setSource(source: source)
        cell.selectionStyle = .none
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        performSegue(withIdentifier: "showWord", sender: self)
    }
    
}
