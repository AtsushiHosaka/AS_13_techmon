//
//  LobbyViewController.swift
//  AS_13_techmon
//
//  Created by 保坂篤志 on 2022/05/13.
//

import UIKit

class LobbyViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var staminaLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    let techMonManager = TechMonManager.shared
    
    var stamina: Int = 100
    var staminaTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = "勇者"
        staminaLabel.text = "\(stamina) / 100"
        
        staminaTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(updateStaminaValue), userInfo: nil, repeats: true)
        
        staminaTimer.fire()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        techMonManager.playBGM(fileName: "lobby")
        
        updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        techMonManager.stopBGM()
    }
    
    func updateUI() {
        
        let player = techMonManager.player
        levelLabel.text = "Lv. \(player?.level ?? 0)"
        
    }
    
    @IBAction func toBattle(_ sender: Any) {
        
        if stamina >= 50 {
            
            stamina -= 50
            staminaLabel.text = "\(stamina) / 100"
            
            performSegue(withIdentifier: "toBattle", sender: nil)
        }else {
            
            let alert = UIAlertController(title: "バトルに行けません", message: "スタミナをためてください", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func updateStaminaValue() {
        
        if stamina < 100 {
            
            stamina += 1
            staminaLabel.text = "\(stamina) / 100"
        }
    }
    

}
