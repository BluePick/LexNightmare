//
//  GameViewController+Snapshot.swift
//  LexNightmare
//
//  Created by Lex Tang on 3/16/15.
//  Copyright (c) 2015 LexTang.com. All rights reserved.
//

import UIKit
import SpriteKit

extension GameViewController
{
    var snapshot: UIImage {
        get {
            UIGraphicsBeginImageContextWithOptions(skView.bounds.size, false, UIScreen.mainScreen().scale)
            skView.drawViewHierarchyInRect(skView.bounds, afterScreenUpdates: true)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
    }
    
    func clearWithSnapshot() {
        let image = snapshot
        for node in scene.children {
            if node.isKindOfClass(SKShapeNode.self) {
                let circle = node as! SKShapeNode
                if let n = circle.name {
                    if n == "circle" {
                        circle.runAction(SKAction.removeFromParent())
                    }
                }
            }
        }
        
        let snapshotTexture = SKTexture(image: image)
        let snapshotNode = SKSpriteNode(texture: snapshotTexture)
        snapshotNode.name = "snapshot"
        snapshotNode.size = scene.size
        snapshotNode.zPosition = 1
        snapshotNode.position = skView.center
        
        scene.insertChild(snapshotNode, atIndex: 1)
    }
    
    func removeSnapshot() {
        if let imageNode = scene.childNodeWithName("snapshot") {
            imageNode.runAction(SKAction.removeFromParent())
        }
    }
}
