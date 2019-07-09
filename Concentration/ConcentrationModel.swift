//
//  modelOfConcentration.swift
//  Concentration
//
//  Created by 冯鑫 on 2019/6/25.
//  Copyright © 2019 HarminDu. All rights reserved.
//

import Foundation

struct ConcentrationModel {
    /** 设计：
     1. Model里肯定需要一组卡片
        1.1 Card的数量在init的时候确定（说的是有几对卡片，不是几张）
        1.2 init的时候，将每一对Card放进数组（期间注意体会struct的值拷贝）
     2. Model需要完成用户翻卡片后的处理过程
        2.1 清楚整个流程
        2.2 流程如下：
            首先当用户选择一张Card的时候有2种情况：
            1. 这个卡片已经匹配了 ➡️ 什么也不做
            2. 这个卡片没有匹配 ➡️ 翻过来
                2.1 有一张向上的卡片 ➡️ 记录当前没有向上的卡片
                    2.2.1 和这个匹配 ➡️ 设置匹配
                    2.2.2 不匹配 ➡️ 什么也不做
                2.2 当前没有向上的卡片 or 已经有两张向上的卡片 ➡️ 记录它为向上的卡片
     */
    
    private(set) var cards = [Card]()
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        // look at all the cards and see if you find only one that's face up
        // if so, return it, else return nil
        get{
            var foundIndex: Int?
            for index in cards.indices {
                if cards[index].isFaceUp {
                    if foundIndex == nil {
                        foundIndex = index
                    } else {
                        return nil
                    }
                }
            }
            return foundIndex
        }
        // turn all the cards face down except the card at index newValue
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        if !cards[index].isMatched {
            // 情况1: 没有卡片朝上 -》 翻过来这张卡片
            // 情况2: 有两个卡片朝上（可能匹配可能不匹配）-〉当再选择这张卡片时，让这两张卡片都翻下去
            // 情况3: 已经有一个卡片朝上，进行匹配
            if let matchIndex = indexOfOneAndOnlyFaceUpCard , matchIndex != index { // 后面这个条件确保不是点了同一张图片
                // check if cards match
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                // indexOfOneAndOnlyFaceUpCard = nil
            } else {
                // either no cards or 2 cards are face up
//                for flipDownIndex in cards.indices {
//                    cards[flipDownIndex].isFaceUp = false
//                }
                indexOfOneAndOnlyFaceUpCard = index
            }
            cards[index].isFaceUp = true
        }
        /*
        if cards[index].isFaceUp {
            cards[index].isFaceUp = false
        } else {
            cards[index].isFaceUp = true
        }
         */
    }
    
    func isNewCard(of index: Int) -> Bool {
        return cards[index].isFaceUp == false && cards[index].isMatched == false;
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): you must have at least one pair of cards")
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            //let matchingCard = card // 因为struct是值拷贝
            //cards.append(card)
            //cards.append(card) // 这里好好理解一下
            cards += [card, card]
        }
        // Shuffle the cards
        cards.shuffle()
        /*
        for index in cards.indices {
            print("\(index): \(cards[index].identifier)  \(cards[index].isFaceUp)  \(cards[index].isMatched)")
        }
         */
    }
}
