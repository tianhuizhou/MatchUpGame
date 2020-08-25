//
//  ViewController.swift
//  MatchUpApp
//
//  Created by Tianhui Zhou on 8/21/20.
//  Copyright © 2020 Tianhui Zhou. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timerLabel: UILabel!
    
    
    let model = CardModel()
    var cardsArray = [Card]()
    var level = 8
    
    var timer:Timer?
    var milliseconds: Int = 50 * 1000
    var firstFlippedCard: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cardsArray = model.getCards(gameLevel: level)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    @objc func timerFired() {
        
        milliseconds -= 1
        
        let seconds: Double = Double(milliseconds)/1000.0
        timerLabel.text = String(format: "Time left: %.2f", seconds)
        
        if milliseconds == 0 {
            
            timerLabel.textColor = UIColor.red
            timer?.invalidate()
            
            checkForGameEnd()
            return
        }
    }
    //how many item do we want to display, return the sum of item
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //the number of cards
        return cardsArray.count
        
    }
    
    //display what exactlly cards need to display at the cell
    //what type of cell we want to use it at here
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        return cell
    }
    
    //to configure the cell before we display
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let cardCell = cell as? CardCollectionViewCell
        let card = cardsArray[indexPath.row]
        
        cardCell?.configureCell(card: card)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //check the timer
        if milliseconds <= 0 {
            return 
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        if cell?.card?.isFlipped == false && cell?.card?.isMatched == false {
            cell?.flipUp()
            
            if firstFlippedCard == nil {
                //The card is flipped is the first one
                firstFlippedCard = indexPath
            } else {
                
                checkForMatch(indexPath)
                
            }
        }
    }
    
    //Game logic methods
    
    func checkForMatch(_ secondFlippedCard: IndexPath) {
        
        let cardOne = cardsArray[firstFlippedCard!.row]
        let cardTwo = cardsArray[secondFlippedCard.row]
        
        //get the collection view cells that display
        let cellOne = collectionView.cellForItem(at: firstFlippedCard!) as? CardCollectionViewCell
        let cellTwo = collectionView.cellForItem(at: secondFlippedCard) as? CardCollectionViewCell
        
        if cardOne.imageName == cardTwo.imageName {
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            cellOne?.remove()
            cellTwo?.remove()
            
            checkForGameEnd()
           
        } else {
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            cellOne?.flipDown()
            cellTwo?.flipDown()
        }
        
        firstFlippedCard = nil
    }
    
    func checkForGameEnd() {
        var isWon = true
        
        for card in cardsArray {
            if card.isMatched == false {
                isWon = false
                break
            }
        }
        
        if isWon {
            showAlert(title: "Congradulation!", message: "You got it!")
            level += 1
        } else {
            if milliseconds <= 0 {
                showAlert(title: "Time's Up!", message: "You lose!")
                level = 8
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        //handler means the further action/codes we want to execute after press the OK button
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { action in
            //reset datas as what we initialize in the beginning
            self.cardsArray.removeAll()
            self.cardsArray = [Card]()
            self.cardsArray = self.model.getCards(gameLevel: self.level)
            //the most important step: reload the collection view.
            self.collectionView.reloadData()
            self.milliseconds = 30 * 1000
            self.timerLabel.textColor = UIColor.black
            self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.timerFired), userInfo: nil, repeats: true)
            
            RunLoop.main.add(self.timer!, forMode: .common)
            
        })
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }

}

