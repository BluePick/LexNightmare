//
//  GameViewController+Share.swift
//  LexNightmare
//
//  Created by Lex Tang on 3/16/15.
//  Copyright (c) 2015 LexTang.com. All rights reserved.
//

import UIKit

extension GameViewController {

    @IBAction func didTapShareButton(sender: UIButton)
    {
        let format = NSLocalizedString("I helped Lex fall asleep for %d seconds.", comment: "Sharing text")
        let text = String(format: format, _currentScore)
        let appStoreURL = NSURL(string: "https://itunes.apple.com/app/lexnightmare/id976943265")!
        let image = self.snapshot
        
        let activities = [text, appStoreURL, image]
        let activityVC = UIActivityViewController(activityItems: activities, applicationActivities: nil)
        
        self.presentViewController(activityVC, animated: true, completion: nil)
    }

}
