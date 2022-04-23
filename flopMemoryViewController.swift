//
//  flopMemoryViewController.swift
//  funGame
//
//  Created by 陳秉軒 on 2022/4/16.
//

import UIKit
import AVFoundation

class flopMemoryViewController: UIViewController {

    
    @IBOutlet var simpsonsOutlet: [UIButton]!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    
    var totalMoney = 0
    var simpsons = [Simpson]()
    var numArray = [Int]()
    var time: Timer?
    var seconds = 60
    var finishNum = 0
    var player: AVPlayer?
    var player2: AVPlayer?
    var delegate: SentBackData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalLabel.text = "$\(totalMoney)"
        startgame(go:false)
        createGame()
        for i in 0...simpsonsOutlet.count-1{
            simpsonsOutlet[i].setImage(simpsons[i].image, for: .normal)
            simpsonsOutlet[i].alpha = 1
            UIView.transition(with: simpsonsOutlet[i], duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
            
        }
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [self] _ in
            for i in 0...simpsonsOutlet.count-1{
                simpsonsOutlet[i].setImage(UIImage(named: "back"), for: .normal)
                UIView.transition(with: simpsonsOutlet[i], duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
                mus(name: "456")
                startgame(go:true)
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.dissmissback(data: totalMoney)
    }
    
    @IBAction func simpsonsButton(_ sender: UIButton) {
        //開始倒數
        if time == nil{
            time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(upDateTime), userInfo: nil, repeats: true)
        }
        
        if let index = simpsonsOutlet.firstIndex(of: sender){
            //死掉的牌不能再執行程式
            if simpsons[index].isAlive == false{
                return
            }
            if numArray.count == 0{
                flop(index: index)
                numArray.append(index)
                mus(name: "456")
                //numArray.count == 1 限制翻完兩張不能馬上翻第三張
            }else if numArray.count == 1{
                if numArray.contains(index){
                    flop(index: index)
                    numArray.removeAll()
                    mus(name: "456")
                }else{
                    mus(name: "456")
                    flop(index: index)
                    numArray.append(index)
                    if simpsons[numArray[0]].number == simpsons[numArray[1]].number{
                        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [self] _ in
                            for i in numArray{
                                sameImage(index: i)
                                mus2(name: "correct")
                            }
                            numArray.removeAll()
                            finishNum += 1
                            if finishNum == 8{
                                time?.invalidate()
                                if seconds > 39 {
                                    let alert = UIAlertController(title: "太神啦!!", message: "恭喜你獲得$30000", preferredStyle: .alert)
                                    let action = UIAlertAction(title: "ok", style: .default) { [self] UIAlertAction in
                                        totalMoney += 30000
                                        totalLabel.text = "$\(totalMoney)"
                                        reset()
                                    }
                                    alert.addAction(action)
                                    present(alert, animated: true)
                                }else if seconds > 19{
                                    let alert = UIAlertController(title: "太厲害了!!", message: "恭喜你獲得$10000", preferredStyle: .alert)
                                    let action = UIAlertAction(title: "ok", style: .default) { [self] UIAlertAction in
                                        totalMoney += 10000
                                        totalLabel.text = "$\(totalMoney)"
                                        reset()
                                    }
                                    alert.addAction(action)
                                    present(alert, animated: true)
                                }else{
                                    let alert = UIAlertController(title: "不錯哦!!", message: "恭喜你獲得$5000", preferredStyle: .alert)
                                    let action = UIAlertAction(title: "ok", style: .default) { [self] UIAlertAction in
                                        totalMoney += 5000
                                        totalLabel.text = "$\(totalMoney)"
                                        reset()
                                    }
                                    alert.addAction(action)
                                    present(alert, animated: true)
                                }
                            }
                        }
                    }else{
                        Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { [self] _ in
                            for (_,num) in numArray.enumerated(){
                                flop(index: num)
                            }
                            numArray.removeAll()
                        }
                    }
                }
            }
        }
    }
    @IBAction func resetButton(_ sender: UIButton) {
        reset()
    }
    //判斷如果是相同圖案就死掉並且改變透明度
    func sameImage(index:Int){
        simpsons[index].isAlive = false
        simpsonsOutlet[index].alpha = 0.5
        UIView.transition(with: simpsonsOutlet[index], duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
    }
    //翻牌轉換
    func flop(index:Int){
        if simpsons[index].isFlipped == true{
            simpsonsOutlet[index].setImage(UIImage(named: "back"), for: .normal)
            UIView.transition(with: simpsonsOutlet[index], duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            simpsons[index].isFlipped = false
        }else{
            simpsonsOutlet[index].setImage(simpsons[index].image, for: .normal)
            UIView.transition(with: simpsonsOutlet[index], duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
            simpsons[index].isFlipped = true
        }
    }
    //每過一秒執行此func
    @objc func upDateTime(){
        seconds -= 1
        if seconds == 0{
            time?.invalidate()
            let alert = UIAlertController(title: "挑戰失敗", message: "輸家是沒有獎金的", preferredStyle: .alert)
            let action = UIAlertAction(title: "ok", style: .default) { [self] UIAlertAction in
                reset()
            }
            alert.addAction(action)
            present(alert, animated: true)
        }
        timeLabel.text = "\(seconds)"
    }
    //重新開始
    func reset(){
        time?.invalidate()
        time = nil
        seconds = 60
        finishNum = 0
        timeLabel.text = "\(seconds)"
        numArray = [Int]()
        simpsons = [Simpson]()
        createGame()
        startgame(go:false)
        for i in 0...simpsonsOutlet.count-1{
            simpsonsOutlet[i].setImage(simpsons[i].image, for: .normal)
            simpsonsOutlet[i].alpha = 1
            UIView.transition(with: simpsonsOutlet[i], duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
            mus(name: "456")
        }
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [self] _ in
            for i in 0...simpsonsOutlet.count-1{
                simpsonsOutlet[i].setImage(UIImage(named: "back"), for: .normal)
                UIView.transition(with: simpsonsOutlet[i], duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
                mus(name: "456")
                startgame(go:true)
            }
        }
    }
    func startgame(go:Bool){
        if go == true{
            for i in simpsonsOutlet{
                i.isEnabled = true
            }
        }else{
            for i in simpsonsOutlet{
                i.isEnabled = false
            }
        }
        
    }
    
    func mus(name:String){
        if let url = Bundle.main.url(forResource: name, withExtension: "mp3"){
            player = AVPlayer(url: url)
            player?.play()
        }
    }
    
    func mus2(name:String){
        if let url = Bundle.main.url(forResource: name, withExtension: "mp3"){
            player2 = AVPlayer(url: url)
            player2?.play()
        }
    }
}
