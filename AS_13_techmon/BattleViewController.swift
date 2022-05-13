//
//  BattleViewController.swift
//  AS_13_techmon
//
//  Created by 保坂篤志 on 2022/05/13.
//

import UIKit

class BattleViewController: UIViewController {

    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var playerHPLabel: UILabel!
    @IBOutlet weak var playerMPLabel: UILabel!
    @IBOutlet weak var playerTPLabel: UILabel!
    
    @IBOutlet weak var enemyNameLabel: UILabel!
    @IBOutlet weak var enemyImageView: UIImageView!
    @IBOutlet weak var enemyHPLabel: UILabel!
    @IBOutlet weak var enemyMPLabel: UILabel!
    
    let techMonManager = TechMonManager.shared
    
    var player: Character!
    var enemy: Character!
    
    var gameTimer: Timer!
    var isPlayerAttackAvailable: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        player = techMonManager.player
        enemy = techMonManager.enemy

        playerNameLabel.text = "勇者"
        playerImageView.image = UIImage(named: "yusya.png")
        
        enemyNameLabel.text = "龍"
        enemyImageView.image = UIImage(named: "monster.png")
        
        updateUI()
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateGame), userInfo: nil, repeats: true)
        
        gameTimer.fire()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        techMonManager.playBGM(fileName: "BGM_battle001")
        
        player.resetStatus()
        enemy.resetStatus()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        techMonManager.stopBGM()
    }
    
    @objc func updateGame() {
        
        player.currentMP += 1
        if player.currentMP >= player.maxMP {
            
            isPlayerAttackAvailable = true
            player.currentMP = player.maxMP
        }else {
            
            isPlayerAttackAvailable = false
        }
        
        enemy.currentMP += 1
        if enemy.currentMP >= enemy.maxMP {
            
            enemyAttack()
            enemy.currentMP = 0
        }
        
        updateUI()
    }
    
    func enemyAttack() {
        
        techMonManager.damageAnimation(imageView: playerImageView)
        techMonManager.playSE(fileName: "SE_attack")
        
        player.currentHP -= 20
        
        updateUI()
        
        judgeBattle()
    }
    
    func finishBattle(vanishImageView: UIImageView, isPlayerWin: Bool) {
        
        techMonManager.vanishAnimation(imageView: vanishImageView)
        
        techMonManager.stopBGM()
        gameTimer.invalidate()
        
        isPlayerAttackAvailable = false
        
        var finishMessage: String = ""
        
        if isPlayerWin {
            
            techMonManager.playSE(fileName: "SE_fanfare")
            finishMessage = "勇者の勝利！"
            
            techMonManager.player.level += 1
        }else {
            
            techMonManager.playSE(fileName: "SE_gameover")
            finishMessage = "勇者の敗北…"
        }
        
        let alert = UIAlertController(title: "バトル終了", message: finishMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }

    @IBAction func attackAction(_ sender: Any) {
        
        if isPlayerAttackAvailable {
            
            techMonManager.damageAnimation(imageView: enemyImageView)
            techMonManager.playSE(fileName: "SE_attack")
            
            let critical = Int.random(in: 0...9)
            if critical < 2 {
                
                enemy.currentHP -= player.attackPoint * 2
            }else {
                
                enemy.currentHP -= player.attackPoint
            }
            
            player.currentTP += 10
            if player.currentTP >= player.maxTP {
                
                player.currentTP = player.maxTP
            }
            player.currentMP = 0
            
            judgeBattle()
        }
    }
    
    @IBAction func tameruAction(_ sender: Any) {
        
        if isPlayerAttackAvailable {
            
            techMonManager.playSE(fileName: "SE_charge")
            player.currentTP += 40
            
            if player.currentTP >= player.maxTP {
                
                player.currentTP = player.maxTP
            }
            
            player.currentMP = 0
        }
    }
    
    @IBAction func fireAction(_ sender: Any) {
        
        if isPlayerAttackAvailable && player.currentTP >= 40 {
            
            techMonManager.damageAnimation(imageView: enemyImageView)
            techMonManager.playSE(fileName: "SE_fire")
            
            enemy.currentHP -= 100
            
            player.currentTP -= 40
            
            if player.currentTP <= 0 {
                
                player.currentTP = 0
            }
            
            player.currentMP = 0
            
            judgeBattle()
        }
    }
    
    func updateUI() {
        
        playerHPLabel.text = "\(player.currentHP) / \(player.maxHP)"
        playerMPLabel.text = "\(player.currentMP) / \(player.maxMP)"
        playerTPLabel.text = "\(player.currentTP) / \(player.maxTP)"
        
        enemyHPLabel.text = "\(enemy.currentHP) / \(enemy.maxHP)"
        enemyMPLabel.text = "\(enemy.currentMP) / \(enemy.maxMP)"
    }
    
    func judgeBattle() {
        
        if player.currentHP <= 0 {
            
            finishBattle(vanishImageView: playerImageView, isPlayerWin: false)
        }else if enemy.currentHP <= 0 {
            
            finishBattle(vanishImageView: enemyImageView, isPlayerWin: true)
        }
    }
    
}
