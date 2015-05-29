//
//  GameViewController.swift
//  LexNightmare
//
//  Created by Lex Tang on 3/12/15.
//  Copyright (c) 2015 LexTang.com. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit

class GameViewController: UIViewController, GameSceneDelegate, GKGameCenterControllerDelegate {
    
    @IBOutlet weak var sleepButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var leaderboardButton: UIButton!
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var skView: SKView!
    @IBOutlet weak var controlPanel: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var _leaderboardID = ""
    var _gameCenterEnabled = false
    var _currentScore: UInt64 = 0
    
    lazy var scene: GameScene = {
        let s = GameScene()
        s.gameDelegate = self
        return s
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authenticateLocalPlayer()
        
        skView.ignoresSiblingOrder = true
        skView.presentScene(scene)
        
        controlPanel.alpha = 0
        muteButton.selected = GameDefaults.sharedDefaults.mute
        
        leaderboardButton.titleLabel!.text = NSLocalizedString("Leaderboard", comment: "Game Center Leaderboard")
        sleepButton.titleLabel!.text = NSLocalizedString("Sleep", comment: "Sleep again button")
        shareButton.titleLabel!.text = NSLocalizedString("Share", comment: "Share button title")
        muteButton.titleLabel!.text = NSLocalizedString("Mute", comment: "Mute button title")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        scene.size = skView.bounds.size
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func restart(sender: UIButton) {
        controlPanel.alpha = 0
        removeSnapshot()
        scene.restart()
    }
    
    @IBAction func didTapMuteButton(sender: UIButton) {
        sender.selected = !sender.selected
        GameDefaults.sharedDefaults.mute = sender.selected
    }
    
    
    func gameDidOver(score: Int64) {
        
        _currentScore = UInt64(score)
        scoreLabel.text = "\(score)'"
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.8 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.clearWithSnapshot()
            UIView.animateWithDuration(0.4) {
                self.controlPanel.alpha = 1.0
            }
        }
        
        reportScore(Int64(score))
    }
    
    @IBAction func showLeaderboard(sender: UIButton) {
        showLeaderboardAndAchievements(true)
    }
}
