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
    @IBOutlet weak var titleView: UIView!
    
    
    @IBOutlet weak var sourceImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var sourcesTableHeightConstraint: NSLayoutConstraint!
    
    var source = Source()
    private var wordList: Array<WordUnit>? = nil
    var customNavigationBar = UINavigationBar()
    
    private var originalImageHeight: CGFloat = 0
    private var originalTableHeight: CGFloat {
        
        return view.frame.height - originalImageHeight
    }
    private var lastContentOffset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.tintColor = Constants.Colors.deepRed;
        startAnimation()
        loadWords()
        setupScreen()
        setupTitleView()
        setupNavigationBar()
        setupValues()
        
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        originalImageHeight = 350
        sourcesTableHeightConstraint.constant = originalTableHeight
    }
    override func viewWillAppear(_ animated: Bool) {
        customNavigationBar.contentMode = .scaleAspectFill
    }
    override func viewDidAppear(_ animated: Bool) {
        customNavigationBar.contentMode = .bottom
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
    func setupTitleView() {
        titleView.layer.shadowColor = UIColor.white.cgColor
        titleView.layer.shadowOpacity = 0.2
        titleView.layer.shadowOffset = .init(width: -3, height: -8)
        titleView.layer.shadowRadius = 10
        titleView.layer.cornerRadius = 10
        titleView.blurView.intensity = 0.3
    }
    func setupNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Localizables.Sources.sourceDictionaryCell) as! DictionaryViewCell
        cell.setWord(word: currentWord)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        performSegue(withIdentifier: "showWord", sender: self)
    }
    
}

extension SourceScreen: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let guide = view.safeAreaLayoutGuide
        let height = guide.layoutFrame.size.height
        
        if (self.lastContentOffset > scrollView.contentOffset.y) {
            if wordTableView.contentOffset.y <= sourceImage.frame.height && sourceImage.frame.height >= 0 {
                self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
                self.navigationController?.navigationBar.shadowImage = UIImage()
                self.navigationController?.navigationBar.isTranslucent = true
                
                self.sourceName.layer.opacity = 1
                self.title?.removeAll()
                sourcesTableHeightConstraint.constant = originalTableHeight
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
            }
        }
        else if (self.lastContentOffset < scrollView.contentOffset.y && sourcesTableHeightConstraint.constant != height - 8) {
            if sourceImage.frame.height >= 0 && sourceImage.frame.height <= originalImageHeight{
                self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
                self.navigationController?.navigationBar.shadowImage = nil
                self.navigationController?.navigationBar.isTranslucent = false
                
                sourcesTableHeightConstraint.constant = view.frame.height - 80
                

                UIView.animate(withDuration: 0.5, animations: {
                    self.view.layoutIfNeeded()
                }, completion: { _ in
                    self.title = self.source.name
                })
            }
        }
//        UIView.animate(withDuration: 0.5) {
//            self.view.layoutIfNeeded()
//        }
        
        // update the new position acquired
        //        self.lastContentOffset = scrollView.contentOffset.y
        
        //
    }
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        if wordTableView.contentOffset.y <= sourcesTableHeightConstraint.constant {
//
//            UIView.animate(withDuration: 0.3, animations: {
//                self.scrollToFirstRow()
//            }, completion: nil)
//        }
//    }
    func scrollToFirstRow() {
        let indexPath = IndexPath(row: 0, section: 0)
        if wordTableView.numberOfRows(inSection: 0) != 0 {
            self.wordTableView.scrollToRow(at: indexPath, at: .top, animated: false)
        }
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
