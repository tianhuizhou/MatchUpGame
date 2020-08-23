//
//  CardModel.swift
//  MatchUpApp
//
//  Created by Tianhui Zhou on 8/21/20.
//  Copyright © 2020 Tianhui Zhou. All rights reserved.
//

import Foundation

class CardModel {
    
    func getCards() -> [Card] {
        
        //declare a new empty array for storing cards
        var arrayOfCards = [Card]()
        
        var arrayOfRamdomNum = [Int]()
        
        while (arrayOfRamdomNum.count < 8){
            
            let randomNumber = Int.random(in: 1...13)
            
            if !arrayOfRamdomNum.contains(randomNumber) {
                
                //add the new random number into the array, no duplicated
                arrayOfRamdomNum.append(randomNumber)
                //a pair of cards
                let cardOne = Card()
                let cardTwo = Card()
            
                cardOne.imageName = "card\(randomNumber)"
                cardTwo.imageName = "card\(randomNumber)"
            
                arrayOfCards += [cardOne, cardTwo]
                
                print(randomNumber)
            }
        }
        
        //randomize the order of cards in the array
        arrayOfCards.shuffle()
        return arrayOfCards
    }
}
