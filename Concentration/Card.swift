//
//  Card.swift
//  Concentration
//
//  Created by 冯鑫 on 2019/6/30.
//  Copyright © 2019 HarminDu. All rights reserved.
//

import Foundation

struct Card {
    /** 设计：
     1. 两个一样的Card要具有相同的标识 identifier
     2. Card的状态
        2.1 是否正面朝上 isFaceUp
        2.2 是否已经被匹配 isMatched
     3. 卡片的初始化 init()
        3.1 Card在init的时候直接分配indentifier
        3.2 Card的indentifier可以用静态函数和静态变量实现自动分配
     */
    var isFaceUp = false
    var isMatched = false
    var identifier:Int
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int { // Cards结构体可以调用，但是结构体对象不可以
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier() // 静态用静态才能不加card.
    }
}
