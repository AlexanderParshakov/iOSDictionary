//
//  SourceScreen.swift
//  WordList
//
//  Created by Alexander Parshakov on 30/09/2019.
//  Copyright © 2019 Alexander Parshakov. All rights reserved.
//

import UIKit
import Lottie

class SourceScreen: UIViewController {
    
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var sourceName: UILabel!
    @IBOutlet weak var sourceImage: UIImageView!
    @IBOutlet weak var wordTableView: UITableView!
    
    var source = Source()
    private var wordList: Array<WordUnit>? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimation()
        loadWords()
        setupScreen()
        setupValues()
    }
    
    func startAnimation() {
        animationView.animation = Animation.named(Constants.ResourceNames.basicLoader)
        animationView.loopMode = .loop
        animationView.play()
    }
    func setupScreen() {
        wordTableView.delegate = self
        wordTableView.dataSource = self
    }
    func setupValues() {
        sourceName.text = source.name
        sourceImage.image = UIImage(data: source.imageData)
    }
}


extension SourceScreen: UITableViewDataSource, UITableViewDelegate {
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let wordUnits = wordList else { return 0 }
        return wordUnits.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentWord = wordList![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Literals.Source.sourceDictionaryCell) as! DictionaryViewCell
        cell.setWord(word: currentWord)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "showWord", sender: self)
    }
    
 }

extension SourceScreen {
    
    func loadWords() {
        NetworkManager.WordUnits.getWords(sourceId: source.id) { [weak self] (result) in
            switch result {
                
                case .success(let words):
                    self?.wordList = words
                    self?.wordTableView.reloadData()
                    self?.wordTableView.isHidden = false
                    if let animation = self?.animationView {
                        animation.removeFromSuperview()
                    }
                case .failure(let error):
                    print("Error: ", error)
            }
        }
    }
}
