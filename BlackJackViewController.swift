//
//  BlackJackViewController.swift
//  funGame
//
//  Created by 陳秉軒 on 2022/4/16.
//

import UIKit
import AVFoundation

class BlackJackViewController: UIViewController {

    
    @IBOutlet var bankerCardImage: [UIImageView]!
    @IBOutlet var playerCardImage: [UIImageView]!
    @IBOutlet weak var secretImage: UIImageView!
    
    @IBOutlet weak var stepperOutlet: UIStepper!
    @IBOutlet weak var allInOutlet: UIButton!
    
    @IBOutlet weak var totalMoneyLabel: UILabel!
    @IBOutlet weak var betLabel: UILabel!
    
    @IBOutlet weak var callOutlet: UIButton!
    @IBOutlet weak var stopOutlet: UIButton!
    @IBOutlet weak var giveUpOutlet: UIButton!
    
    @IBOutlet weak var bankerScoreLabel: UILabel!
    @IBOutlet weak var playerScoreLabel: UILabel!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    //總資產
    var totalMoney = 0
    //賭金
    var bet = 0
    //計算拿第幾張牌
    var cardImageNum = 0
    //存取52張牌的陣列
    var cards = [Card]()
    //玩家與莊家的點數
    var playerScore = 0
    var bankerScore = 0
    //存取玩家與莊家的手牌牌組
    var playerCards = [String]()
    var bankerCards = [String]()
    //判斷A從11變成1是否使用過
    var playerOnce = true
    var bankerOnce = true
    //判斷A是否當過11
    var playerEleven = false
    var bankerEleven = false
    
    var player: AVPlayer?
    //用於回傳資料
    var delegate:SentBackData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalMoneyLabel.text = "$\(totalMoney)"
        stepperOutlet.maximumValue = Double(totalMoney)
        hidden()
        bankerScoreLabel.text = ""
        playerScoreLabel.text = ""
        resultLabel.text = ""
        
        for i in 0...playerCardImage.count-1{
            playerCardImage[i].alpha = 0
            bankerCardImage[i].alpha = 0
        }
        secretImage.alpha = 0
    }
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.dissmissback(data: totalMoney + bet)
    }
    
    
    //設定賭金
    @IBAction func stepperButton(_ sender: UIStepper) {
        if totalMoney < 1000&&bet < 1000{
            let alert = UIAlertController(title: "資金不足", message: "最低賭注為1000$", preferredStyle: .alert)
            let action = UIAlertAction(title: "ok", style: .default)
            alert.addAction(action)
            present(alert, animated: true)
        }else{
            betLabel.text = "$\(Int(sender.value))"
            bet = Int(sender.value)
            totalMoney = Int(sender.maximumValue) - bet
            totalMoneyLabel.text = "$\(totalMoney)"
            if sender.value == 0 {
                callOutlet.isHidden = true
            } else {
                callOutlet.isHidden = false
            }
        }
        
    }
    
    //All in
    @IBAction func allInButton(_ sender: UIButton) {
        if totalMoney < 1000&&bet < 1000{
            let alert = UIAlertController(title: "沒錢還敢All in", message: "是要賭手腳!?", preferredStyle: .alert)
            let action = UIAlertAction(title: "ok", style: .default)
            alert.addAction(action)
            present(alert, animated: true)
        }else{
            bet = totalMoney + bet
            betLabel.text = "$\(bet)"
            totalMoney = 0
            totalMoneyLabel.text = "$\(totalMoney)"
            stepperOutlet.value = Double(bet)
            callOutlet.isHidden = false
        }
        
    }
    
    
    //要牌
    @IBAction func callButton(_ sender: UIButton) {
        stepperOutlet.isHidden = true
        allInOutlet.isHidden = true
        stopOutlet.isHidden = false
        giveUpOutlet.isHidden = false
        
        if cardImageNum == 0{
            firstServe()
        }else if cardImageNum < 4{
            let animator = UIViewPropertyAnimator(duration: 1.5, curve: .linear) {
                self.playerCardImage[self.cardImageNum].alpha = 1
            }
            animator.startAnimation()
            playerCardImage[cardImageNum].image = UIImage(named:cards[0].suits + cards[0].rank )
            myScore()
            playerCards.append(cards[0].rank)
            if playerOnce == true{
                if playerScore > 21&&playerCards.contains("A")&&playerEleven == true{
                    playerScore -= 10
                    playerOnce = false
                }
            }
            playerScoreLabel.text = "\(playerScore)"
            cards.removeFirst()
            cardImageNum += 1
            playerCheck()
            mus()
        }else if cardImageNum == 4{
            
            let animator = UIViewPropertyAnimator(duration: 1.5, curve: .linear) {
                self.playerCardImage[self.cardImageNum].alpha = 1
            }
            animator.startAnimation()
            
            playerCardImage[cardImageNum].image = UIImage(named:cards[0].suits + cards[0].rank )
            myScore()
            playerCards.append(cards[0].rank)
            if playerOnce == true{
                if playerScore > 21&&playerCards.contains("A")&&playerEleven == true{
                    playerScore -= 10
                    playerOnce = false
                }
            }
            
            playerScoreLabel.text = "\(playerScore)"
            cards.removeFirst()
            if playerScore < 22{
                resultLabel.text = "過五關"
                playerResult(win: true, odds: 3)
                hidden()
                reset()
            }else{
                playerCheck()
            }
            mus()
        }
    }
    //停止要牌
    @IBAction func stopButton(_ sender: UIButton) {
        
        let animator = UIViewPropertyAnimator(duration: 1.5, curve: .linear) {
            self.secretImage.alpha = 0
        }
        animator.startAnimation()

        cardImageNum = 2
        hidden()
        if bankerScore < 17{
            while bankerScore < 17&&cardImageNum < 5{
                
                let animator = UIViewPropertyAnimator(duration: 1.5, curve: .linear) {
                    self.bankerCardImage[self.cardImageNum].alpha = 1
                }
                animator.startAnimation()
                
                bankerCardImage[cardImageNum].image = UIImage(named:cards[0].suits + cards[0].rank)
                computerScore()
                bankerCards.append(cards[0].rank)
                if bankerOnce == true{
                        if bankerScore > 21&&bankerCards.contains("A")&&bankerEleven == true{
                            bankerScore -= 10
                            bankerOnce = false
                        }
                    }
                cards.removeFirst()
                cardImageNum += 1
                mus()
            }
            bankerScoreLabel.text = "\(bankerScore)"
            bankerCheck()
        }else{
            bankerScoreLabel.text = "\(bankerScore)"
            bankerCheck()
        }
    }
    //投降輸一半
    @IBAction func giveUpButton(_ sender: UIButton) {
        totalMoney += bet/2
        totalMoneyLabel.text = "\(totalMoney)"
        resultLabel.text = "你投降了\n損失了$\(bet/2)"
        bet = 0
        betLabel.text = "\(bet)"
        stepperOutlet.maximumValue = Double(totalMoney)
        stepperOutlet.value = 0
        
        
        hidden()
        reset()
    }
    //結算輸贏金額
    func playerResult(win:Bool,odds:Float){
        if win == true{
            totalMoney += Int(Float(bet)*odds)
            totalMoneyLabel.text = "$\(totalMoney)"
            resultLabel.text! += "\n恭喜！你贏得了$\(Int(Float(bet)*odds))"
            print(bet)
        }else{
            resultLabel.text! += "\n損失了$\(bet)"
            print(bet)
            print("lose")
        }
        bet = 0
        betLabel.text = "\(bet)"
        stepperOutlet.maximumValue = Double(totalMoney)
        stepperOutlet.value = 0
    }
    //過兩秒重新開始
    func reset(){
        _ = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [self] _ in
            stepperOutlet.isHidden = false
            allInOutlet.isHidden = false
            callOutlet.isHidden = true
            playerEleven = false
            bankerEleven = false
            resultLabel.text = ""
            cardImageNum = 0
            cards = [Card]()
            playerCards = [String]()
            bankerCards = [String]()
            playerScore = 0
            bankerScore = 0
            playerScoreLabel.text = ""
            bankerScoreLabel.text = ""
            resultLabel.text = ""
            playerOnce = true
            bankerOnce = true
            secretImage.alpha = 0
            checkBankrupt()
            for i in 0...playerCardImage.count-1{
                playerCardImage[i].image = UIImage(named: "")
                bankerCardImage[i].image = UIImage(named: "")
                playerCardImage[i].alpha = 0
                bankerCardImage[i].alpha = 0
            }
            if let url = Bundle.main.url(forResource: "123", withExtension: "mp3"){
                player = AVPlayer(url: url)
                player?.play()
            }
        }
        
    }
    //確認玩家手牌是否爆掉
    func playerCheck(){
        if playerScore > 21{
            hidden()
            resultLabel.text = "你爆了!!"
            playerResult(win: false, odds: 0)
            reset()
        }
    }
    //確認莊家手牌是否爆掉
    func bankerCheck(){
        if bankerScore > 21{
            if playerScore == 21{
                resultLabel.text = "莊家爆牌!!\n玩家Black Jack!!"
                playerResult(win: true, odds: 2.5)
            }else{
            resultLabel.text = "莊家爆牌!!"
            playerResult(win: true, odds: 2)
            }
        }else{
            if bankerScore > playerScore{
                resultLabel.text = "莊家獲勝"
                playerResult(win: false, odds: 0)
            }else if bankerScore < playerScore{
                if playerScore == 21{
                    resultLabel.text = "玩家Black Jack!"
                    playerResult(win: true, odds: 2.5)
                }else{
                    resultLabel.text = "玩家獲勝"
                    playerResult(win: true, odds: 2)
                }
                
            }else if bankerScore == playerScore{
                resultLabel.text = "平手"
                totalMoney += bet
                totalMoneyLabel.text = "\(totalMoney)"
                bet = 0
                betLabel.text = "\(bet)"
                stepperOutlet.maximumValue = Double(totalMoney)
                stepperOutlet.value = 0
            }
        }
        reset()
    }
    //計算player點數
    func myScore(){
        switch cards[0].rank{
        case "J","Q","K":
            playerScore += 10
        case "A":
            if playerScore < 11{
                playerScore += 11
                playerEleven = true
            }else{
                playerScore += 1
            }
        default:
            playerScore += Int(cards[0].rank)!
        }
    }
    //計算banker點數
    func computerScore(){
        switch cards[0].rank{
        case "J","Q","K":
            bankerScore += 10
            
        case "A":
            if bankerScore < 11{
                bankerScore += 11
                bankerEleven = true
            }else{
                bankerScore += 1
                
            }
        default:
            bankerScore += Int(cards[0].rank)!
        }
    }
    //隱藏按鈕
    func hidden(){
        callOutlet.isHidden = true
        stopOutlet.isHidden = true
        giveUpOutlet.isHidden = true
    }
    //確認是否資金不足
    func checkBankrupt(){
        if totalMoney < 1000&&bet == 0{
            let Alert = UIAlertController(title: "資金不足!!", message: "去借點錢再來賭吧", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { [self]  UIAlertAction in
                navigationController?.popViewController(animated: true)
            }
            Alert.addAction(action)
            present(Alert, animated: true)
        }
    }
    
    
    //首輪發牌
    func firstServe(){
        //生出牌組
        createCards()
        
        let animator = UIViewPropertyAnimator(duration: 1, curve: .linear) {
            self.secretImage.alpha = 1
        }
        animator.startAnimation()
        
        for i in 0...1{
            playerCardImage[i].image = UIImage(named:cards[0].suits + cards[0].rank)
            
            let animator = UIViewPropertyAnimator(duration: 1.5, curve: .linear) {
                self.playerCardImage[i].alpha = 1
            }
            animator.startAnimation()
    
            myScore()
            playerCards.append(cards[0].rank)
            
            playerScoreLabel.text = "\(playerScore)"
            cards.removeFirst()
            
            bankerCardImage[i].image = UIImage(named:cards[0].suits + cards[0].rank)
            
            let animator2 = UIViewPropertyAnimator(duration: 1.5, curve: .linear) {
                self.bankerCardImage[i].alpha = 1
            }
            animator2.startAnimation()
            
            computerScore()
            bankerCards.append(cards[0].rank)
            cards.removeFirst()
            
        }
        //只顯示莊家第二張牌的點數
        switch bankerCards[1] {
        case "A":
            bankerScoreLabel.text = "11"
        case "J","Q","K":
            bankerScoreLabel.text = "10"
        default:
            bankerScoreLabel.text = bankerCards[1]
        }
        mus()
        Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false) { _ in
            self.mus()
        }
        cardImageNum += 2
    }
    
    func mus(){
        if let url = Bundle.main.url(forResource: "456", withExtension: "mp3"){
            player = AVPlayer(url: url)
            player?.play()
        }
    }
    
    
    
    
    
    
    
    
    //NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: .main) { [weak self] _ in
//                self?.player?.seek(to: CMTime.zero)
//                self?.player?.play()
//            }
       
    
    
}

//UIView.transition(with: bankerCardImage[i], duration: 1, options: .transitionFlipFromRight, animations: nil, completion: nil)
