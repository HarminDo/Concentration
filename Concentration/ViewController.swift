//
//  ViewController.swift
//  Concentration
//
//  Created by 冯鑫 on 2019/6/25.
//  Copyright © 2019 HarminDu. All rights reserved.
//


// 作业：
// 1. 添加一个按钮，按下开始一场新的游戏
// 2. 打乱顺序
import UIKit

class ViewController: UIViewController {
    // Model
    // lazy 直到有人要用这个变量的时候，它才初始化
    // lazy 不可以使用 didSet语法
    private lazy var game = ConcentrationModel(numberOfPairsOfCards: numberOfPairsOfCards) // HEAR!!
    // 只读计算属性：只有getter没有setter的计算属性叫只读计算属性
    var numberOfPairsOfCards: Int{
        return (cardButtons.count+1) / 2
    }
    
    private(set) var flipCount = 0 {
        didSet { // 属性观察期 用于使得UI的东西和代码里的某一个属性保持一致
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    @IBOutlet private weak var flipCountLabel: UILabel!
    @IBOutlet private var cardButtons: [UIButton]!
    
    
    // 创建的时候typet要从any -> UIButton
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender), game.isNewCard(of: cardNumber){
            flipCount += 1
            game.chooseCard(at: cardNumber)
            // 接下来需要：从Model获取数据更新View
            updataViewFromModel()
        }
    }
    // MARK: ???
    private func updataViewFromModel() {
        // 遍历所有的卡片的按钮，对照game模型，然后正确设置按钮
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
            }
        }
    }
    
    private var emojiAll = ["👻", "🎃", "💎", "🐳", "🐵", "🌻", "🎂", "🚗"]
    private lazy var emojiChoices = emojiAll
    
    private var emoji = [Int: String]() // Dictionary
    
    private func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            emoji[card.identifier] = emojiChoices.remove(at: emojiChoices.count.arc4random)
        }
        /*
        if emoji[card.identifier] != nil {
            return emoji[card.identifier]!
        } else {
            return "?"
        }
         */
        // 以上等价于
        return emoji[card.identifier] ?? "?"
    }
    
    // 重启游戏
    @IBAction func restartGame(_ sender: UIButton) {
        game = ConcentrationModel(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        updataViewFromModel()
        emoji = [Int: String]()
        emojiChoices = emojiAll
        flipCount = 0
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
        
    }
}
