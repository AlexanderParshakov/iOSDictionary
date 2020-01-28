//
//  SelectSourceScreen.swift
//  NewDictionary
//
//  Created by Alexander Parshakov on 11/17/19.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import UIKit
import Lottie

protocol SelectSourceDelegate {
    func selectSource(selectedSource: Source)
}

class SelectSourceScreen: UIViewController {
    
    @IBOutlet weak var sourcesTableView: UITableView!
    @IBOutlet weak var animationView: AnimationView!
    
    var sourceList: [Source] = [Source]()
    var selectedSource = Source()
    var delegate: SelectSourceDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sourcesTableView.delegate = self
        sourcesTableView.dataSource = self
        loadSources()
        sourceList = sourceList.filter({ $0.id == selectedSource.id}) + sourceList.filter({ $0.id != selectedSource.id})
    }
}

extension SelectSourceScreen: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sourceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let source = (sourceList[indexPath.row])
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Localizables.Sources.selectSourceCell) as! SelectSourceCell
        cell.setSource(source: source)
        if cell.source.id == selectedSource.id {
            cell.sourceName.textColor = .systemRed
            cell.sourceImage.layer.borderColor = UIColor.systemRed.cgColor
            cell.sourceImage.layer.borderWidth = 3
        }
        else {
            cell.sourceName.textColor = UIColor(named: "FontColor")
            cell.sourceImage.layer.borderWidth = 0
        }
        cell.selectionStyle = .none
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = sourcesTableView.indexPathForSelectedRow
        let currentCell = sourcesTableView.cellForRow(at: indexPath!) as! SelectSourceCell
        
        selectedSource = currentCell.source
        self.delegate?.selectSource(selectedSource: currentCell.source)
        
        sourcesTableView.reloadData()
        
        //        let userDefaults = UserDefaults.standard
        //        userDefaults.set(currentCell.language, forKey: Constants.UserDefaultKeys.lastUsedLanguage)
    }
}


// MARK: - Data Manipulation
extension SelectSourceScreen {
    func loadSources() {
        sourceList = RealmManager.Sources.retrieve()
        if (sourceList.count > 0) {
            LottieManager.uncurtainScreen(animationView: animationView, tableView: sourcesTableView)
        }
            
        else {
            NetworkManager.Sources.getAll { [weak self] (result) in
                switch result {
                    case .success(let sources):
                        self?.sourceList = sources
                        self?.sourcesTableView.reloadData()
                        guard let animation = self?.animationView else { return }
                        LottieManager.uncurtainScreen(animationView: animation, tableView: self?.sourcesTableView)
                    case .failure(let error):
                        print("Error: ", error)
                }
            }
        }
    }
}

