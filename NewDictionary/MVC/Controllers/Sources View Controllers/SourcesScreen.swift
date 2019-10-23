//
//  SourceScreen.swift
//  WordList
//
//  Created by Alexander Parshakov on 28/09/2019.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import UIKit
import CoreData
import Lottie
class SourcesScreen: UIViewController {
    
    @IBOutlet weak var sourcesTableView: UITableView!
    @IBOutlet weak var animationView: AnimationView!
    
    
    private var sourceList: Array<Source>? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startAnimation()
        setupScreen()
        loadSources()
    }
    
    func startAnimation() {
        animationView.animation = Animation.named(Constants.ResourceNames.basicLoader)
        animationView.loopMode = .loop
        animationView.play()
    }
    func setupScreen() {
        self.title = "Sources"
        sourcesTableView.isHidden = true
        sourcesTableView.delegate = self
        sourcesTableView.dataSource = self
    }
    func loadSources() {
        NetworkManager.Sources.getAll { [weak self] (result) in
            switch result {
            case .success(let sources):
                self?.sourceList = sources
                self?.sourcesTableView.reloadData()
                self?.sourcesTableView.isHidden = false
                self?.animationView.removeFromSuperview()
            case .failure(let error):
                print("Error: ", error)
            }
        }
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


extension SourcesScreen: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sourceList?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let source = (sourceList?[indexPath.row])!
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Literals.Source.sourceCell) as! SourcesViewCell
        cell.setSource(source: source)
        cell.selectionStyle = .none
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        performSegue(withIdentifier: "showWord", sender: self)
    }
    
}
