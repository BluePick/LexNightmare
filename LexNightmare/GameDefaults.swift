//
//  GameDefaults.swift
//  LexNightmare
//
//  Created by Lex Tang on 3/16/15.
//  Copyright (c) 2015 LexTang.com. All rights reserved.
//

import UIKit

let kAppGroupIdentifier = "group.LetNightmare"
let kMuteKey = "mute"
let kDidRemoveAdsKey = "didRemoveAds"
let kBestScoreKey = "bestScore"

final public class GameDefaults: NSUserDefaults
{
    public class var sharedDefaults: GameDefaults
    {
        struct Static
        {
            static let sharedInstance: GameDefaults = {
                let instance = GameDefaults(suiteName: kAppGroupIdentifier)!
                return instance
                }()
        }
        
        return Static.sharedInstance
    }
    
    var _mute: NSNumber?
    var mute: Bool {
        get {
            if _mute == nil {
                _mute = NSNumber(bool: boolForKey(kMuteKey))
            }
            return _mute!.boolValue
        }
        set {
            _mute = NSNumber(bool: newValue)
            setBool(newValue, forKey: kMuteKey)
            synchronize()
        }
    }

    var _removeAds: NSNumber?
    var removeAds: Bool {
        get {
            if _removeAds == nil {
                _removeAds = NSNumber(bool: boolForKey(kDidRemoveAdsKey))
            }
            return _removeAds!.boolValue
        }
        set {
            _removeAds = NSNumber(bool: newValue)
            setBool(newValue, forKey: kDidRemoveAdsKey)
            synchronize()
        }
    }
    
    var bestScore: UInt32 {
        get {
            return UInt32(integerForKey(kBestScoreKey))
        }
        set {
            setInteger(Int(newValue), forKey: kBestScoreKey)
            synchronize()
        }
    }
}
