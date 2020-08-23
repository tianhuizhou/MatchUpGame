//
//  CardCollectionViewCell.swift
//  MatchUpApp
//
//  Created by Tianhui Zhou on 8/21/20.
//  Copyright © 2020 Tianhui Zhou. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    var card:Card?
    
    func configureCell(card: Card){
        
        self.card = card
        
        frontImageView.image = UIImage(named: card.imageName)
        
        if card.isMatched == true {
            frontImageView.alpha = 0
            backImageView.alpha = 0
        } else {
            frontImageView.alpha = 1
            backImageView.alpha = 1
        }
        
        if card.isFlipped == true {
            flipUp(speed: 0)
        } else {
            flipDown(speed: 0, delay: 0)
        }
    }
    
    func flipUp(speed: TimeInterval = 0.4) {
        UIView.transition(from: backImageView, to: frontImageView, duration: speed, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
        
        card?.isFlipped = true
    }
    
    func flipDown(speed: TimeInterval = 0.4, delay: TimeInterval = 0.5) {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay){
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: speed, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
        }
        
        card?.isFlipped = false
    }
    
    func remove() {
        //make the card invisible
        backImageView.alpha = 0
        
        UIView.animate(withDuration: 0.4, delay: 0.6, options: .curveEaseOut, animations:{
            self.frontImageView.alpha = 0
        }, completion: nil)
    }
}
