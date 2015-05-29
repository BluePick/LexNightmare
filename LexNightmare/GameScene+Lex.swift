//
//  GameScene+Lex.swift
//  LexNightmare
//
//  Created by Lex Tang on 3/16/15.
//  Copyright (c) 2015 LexTang.com. All rights reserved.
//

import UIKit
import SpriteKit

extension GameScene
{
    func lexNode() -> SKSpriteNode {
        if let lex = childNodeWithName("lex") as! SKSpriteNode? {
            return lex
        } else {
            let texture = SKTexture(image: UIImage(named: "LexAwake")!)
            let node = SKSpriteNode(texture: texture)
            node.name = "lex"
            node.size = CGSizeMake(300, 300)
            node.anchorPoint = CGPointMake(0.5, 0)
            node.position = CGPointMake(screenWidth / 2, 0)
            node.zPosition = 2
            
            addChild(node)
            return node
        }
    }
    
    func showLexAwake() {
        lexNode().texture = SKTexture(image: UIImage(named: "LexAwake")!)
    }
    
    func showLexAsleep() {
        lexNode().texture = SKTexture(image: UIImage(named: "LexAsleep")!)
    }
}
