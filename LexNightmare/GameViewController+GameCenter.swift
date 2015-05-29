//
//  GameViewController+GameCenter.swift
//  LexNightmare
//
//  Created by Lex on 3/15/15.
//  Copyright (c) 2015 LexTang.com. All rights reserved.
//

import UIKit
import GameKit

extension GameViewController {
    
    func authenticateLocalPlayer() {
        let localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {
            viewController, error in
            if viewController != nil {
                self.presentViewController(viewController, animated: true, completion: nil)
            } else {
                if GKLocalPlayer.localPlayer().authenticated {
                    self._gameCenterEnabled = true
                    
                    GKLocalPlayer.localPlayer().loadDefaultLeaderboardIdentifierWithCompletionHandler({
                        leaderboardID, error in
                        if error != nil {
                            println("\(error.localizedDescription)")
                        } else {
                            self._leaderboardID = leaderboardID
                        }
                    })
                } else {
                    self._gameCenterEnabled = false
                }
            }
        }
    }
    
    func reportScore(duration: Int64) {
        if !_gameCenterEnabled {
            return
        }
        
        if GameDefaults.sharedDefaults.bestScore >= UInt32(duration) {
            return
        } else {
            GameDefaults.sharedDefaults.bestScore = UInt32(duration)
        }
        
        let score = GKScore(leaderboardIdentifier: "SleepDuration")
        score.value = duration
        
        GKScore.reportScores([score], withCompletionHandler: {
            error -> Void in
            
        })
    }
    
    func showLeaderboardAndAchievements(shouldShowLeadboard: Bool) {
        let gcViewController = GKGameCenterViewController()
        gcViewController.gameCenterDelegate = self
        
        if shouldShowLeadboard {
            gcViewController.viewState = GKGameCenterViewControllerState.Leaderboards
            gcViewController.leaderboardIdentifier = _leaderboardID
        } else {
            gcViewController.viewState = GKGameCenterViewControllerState.Achievements
        }
        
        presentViewController(gcViewController, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!)
    {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }

}
