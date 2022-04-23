//
//  poker.swift
//  funGame
//
//  Created by 陳秉軒 on 2022/4/16.
//

import Foundation
import UIKit

struct Card{
    let suits:String
    let rank:String
}

extension BlackJackViewController{
    //產生撲克牌
    func createCards(){
        let suits = ["♣️", "♦️", "♥️", "♠️"]
        let ranks = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
        
        for suit in suits {
            for rank in ranks {
                cards.append(Card(suits: suit, rank: rank))
             }
        }
        cards.shuffle()
    }
}


struct Simpson {
    let number:Int
    let image: UIImage
    var isFlipped = false
    var isAlive = true
}

extension flopMemoryViewController{
    
    func createGame(){
        for _ in 0...1{
            for i in 1...8{
                simpsons.append(Simpson(number: i, image: UIImage(named: "\(i)")!))
            }
        }
        simpsons.shuffle()
    }
    
    
    
    
    
    
    
    
}
