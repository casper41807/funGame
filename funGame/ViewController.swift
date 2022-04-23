//
//  ViewController.swift
//  funGame
//
//  Created by 陳秉軒 on 2022/4/16.
//

import UIKit

protocol SentBackData{
    func dissmissback(data:Int)
}

class ViewController: UIViewController,SentBackData {

    func dissmissback(data: Int) {
        totalMoney = data
        totalLabel.text = "$\(totalMoney)"
    }
    
    
    @IBOutlet weak var totalLabel: UILabel!
    var totalMoney = 30000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalLabel.text = "$\(totalMoney)"
        // Do any additional setup after loading the view.
    }

   
    
    
    @IBSegueAction func nextView(_ coder: NSCoder, sender: Any?, segueIdentifier: String?) -> BlackJackViewController? {
        let controller = BlackJackViewController(coder: coder)
        controller?.totalMoney = totalMoney
        controller?.delegate = self
        return controller
    }
    
    
   
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "flopMemory"{
            if let mvc = segue.destination as? flopMemoryViewController{
                mvc.totalMoney = totalMoney
                mvc.delegate = self
            }
        }
    }
    
}

