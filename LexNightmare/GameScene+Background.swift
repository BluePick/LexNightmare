//
//  GameScene+Background.swift
//  LexNightmare
//
//  Created by Lex on 3/16/15.
//  Copyright (c) 2015 LexTang.com. All rights reserved.
//

import UIKit
import SpriteKit

extension GameScene
{
    func loadBackground() {
        if let background = childNodeWithName("background") as! SKSpriteNode? {
            return
        } else {
            let texture = SKTexture(image: UIImage(named: "background")!)
            let node = SKSpriteNode(texture: texture)
            node.size = texture.size()
            node.name = "background"
            node.anchorPoint = CGPointZero
            node.position = CGPointZero
            node.zPosition = 0
            if screenHeight > node.size.height {
                node.size = CGSizeMake(node.size.width / node.size.height * screenHeight, screenHeight)
            }
            
            addChild(node)
        }
    }
}
