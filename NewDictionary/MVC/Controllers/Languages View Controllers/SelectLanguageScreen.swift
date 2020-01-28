//
//  SelectLanguageScreen.swift
//  NewDictionary
//
//  Created by Alexander Parshakov on 11/16/19.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import UIKit

protocol SelectLanguageDelegate {
    func selectLanguage(selectedLang: Language)
}
class SelectLanguageScreen: UIViewController {
    
    @IBOutlet weak var languagesTableView: UITableView!
    
    var langList: Array<Language> = Array<Language>()
    var delegate: SelectLanguageDelegate?
    var selectedLang = Language()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLanguages()
        
        languagesTableView.delegate = self
        languagesTableView.dataSource = self
    }
}

extension SelectLanguageScreen: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return langList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentLang:Language
        currentLang = langList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Localizables.Languages.languageCell) as! LanguageViewCell
        cell.setLanguage(lang: currentLang)
        
        
        if cell.language.id == selectedLang.id {
            cell.customBackgroundView.backgroundColor = .systemRed
        }
        else {
            cell.customBackgroundView.backgroundColor = UIColor(named: "FormColor")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = languagesTableView.indexPathForSelectedRow
        let currentCell = languagesTableView.cellForRow(at: indexPath!) as! LanguageViewCell
        
        selectedLang = currentCell.language
        self.delegate?.selectLanguage(selectedLang: currentCell.language)
        
        languagesTableView.reloadData()
        
//        let userDefaults = UserDefaults.standard
//        userDefaults.set(currentCell.language, forKey: Constants.UserDefaultKeys.lastUsedLanguage)
    }
}


extension SelectLanguageScreen {
    
    func loadLanguages() {
        langList = RealmManager.Languages.retrieve()
        if (langList.count > 0) {
            //            LottieManager.uncurtainScreen(animationView: animationView, tableView: tagsTableView)
        }
            
        else {
            NetworkManager.Languages.getAll { [weak self] (result) in
                switch result {
                    case .success(let languages):
                        self?.langList = languages
                        self?.languagesTableView.reloadData()
                    //                        guard let animation = self?.animationView else { return }
                    //                        LottieManager.uncurtainScreen(animationView: animation, tableView: self?.tagsTableView)
                    case .failure(let error):
                        print("Error: ", error)
                }
            }
        }
    }
}

