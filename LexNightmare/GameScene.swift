//
//  GameScene.swift
//  LexNightmare
//
//  Created by Lex Tang on 3/12/15.
//  Copyright (c) 2015 LexTang.com. All rights reserved.
//

import SpriteKit

protocol GameSceneDelegate: NSObjectProtocol {
    func gameDidOver(score: Int64)
}

class GameScene: SKScene
{
    let inset: CGFloat = 30.0
    
    weak var gameDelegate: GameSceneDelegate?
    
    let circleRadius: CGFloat = 12.0
    
    private lazy var circlePath: CGPath = {
        let rect = CGRectMake(0, 0, self.circleRadius * 2, self.circleRadius * 2)
        return UIBezierPath(ovalInRect: rect).CGPath
    }()
    
    var timer: NSTimer?
    var startTime: NSTimeInterval = 0
    var gameDuration: NSTimeInterval = 0
    
    lazy var screenWidth: CGFloat = {
        return UIScreen.mainScreen().bounds.size.width
    }()
    
    lazy var screenHeight: CGFloat = {
        return UIScreen.mainScreen().bounds.size.height
    }()
    
    var gameOver: Bool = false {
        didSet {
            if let t = timer {
                t.invalidate()
                timer = nil
            }
            if !gameOver {
                showLexAsleep()
                timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("checkStatus:"), userInfo: nil, repeats: true)
                startTime = NSDate().timeIntervalSince1970
            } else {
                showLexAwake()
                gameDuration = NSDate().timeIntervalSince1970 - startTime
            }
        }
    }
    
    func restart() {
        gameOver = false
        for node in children {
            if node.name == "circle" {
                node.removeFromParent()
            }
        }
    }
    
    override func didMoveToView(view: SKView) {
        loadBackground()
        scaleMode = .AspectFill
        gameOver = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("willResignActive:"), name: UIApplicationWillResignActiveNotification, object: nil)
    }
    
    deinit {
        timer?.invalidate()
        delegate = nil
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch!
        let location = touch.locationInNode(self)
        let touchedNode = nodeAtPoint(location)
        
        if touchedNode.name == "circle" {
            touchedNode.removeAllActions()
            
            let scaleUpAction = SKAction.scaleBy(1.5, duration: 0.2)
            let fadeOutAction = SKAction.fadeOutWithDuration(0.2)
            var disappearActions: SKAction? = nil
            if GameDefaults.sharedDefaults.mute {
                disappearActions = SKAction.group([scaleUpAction, fadeOutAction])
            } else {
                let disappearSound = SKAction.playSoundFileNamed("poo.caf", waitForCompletion: false)
                disappearActions = SKAction.group([scaleUpAction, fadeOutAction, disappearSound])
            }
            let actions = SKAction.sequence([disappearActions!, SKAction.removeFromParent()])
            touchedNode.runAction(actions)
        }
    }
    
    func willResignActive(notification: NSNotification) {
        wakeUp()
    }
   
    override func update(currentTime: CFTimeInterval) {
        
    }
    
    func checkStatus(timer: NSTimer) {
        let seed = arc4random_uniform(5)
        if !gameOver && seed > 0 {
            generateCircleAtRandomPosition()
        }
        for node in self.children {
            if node.isKindOfClass(SKShapeNode.self) {
                let circle = node as! SKShapeNode
                if let n = circle.name {
                    if n == "circle" && node.xScale > 12 {
                        wakeUp()
                    }
                }
            }
        }
    }
    
    func generateCircleAtRandomPosition() {
        let sprite = SKShapeNode()
        sprite.name = "circle"
        sprite.xScale = 0
        sprite.path = circlePath
        sprite.fillColor = SKColor(hue: CGFloat(Float(arc4random_uniform(256)) / 255), saturation: 0.5, brightness: 1.0, alpha: 1.0)
        sprite.lineWidth = 0
        
        // Random position
        let x = CGFloat(arc4random_uniform(UInt32(screenWidth - (inset * 2)))) + inset
        let y = CGFloat(arc4random_uniform(UInt32(screenHeight - (inset * 4)))) + inset * 2
        sprite.xScale = 0.5
        sprite.yScale = 0.5
        sprite.position = CGPoint(x: x, y: y + 30)
        sprite.alpha = 0.0
        
        // Random rotation direction
        let rotateDirection: Double = arc4random_uniform(2) == 1 ? 1 : -1
        let rotateDuration = NSTimeInterval(arc4random_uniform(5) + 2)
        let action = SKAction.rotateByAngle(CGFloat(M_PI * rotateDirection), duration: rotateDuration)
        sprite.runAction(SKAction.repeatActionForever(action))
        
        // Scale bigger and bigger
        let scale = SKAction.scaleBy(1.05, duration: 0.35)
        let fadeIn = SKAction.fadeAlphaTo(0.7, duration: 0.5)
        sprite.runAction(SKAction.group([fadeIn, SKAction.repeatActionForever(scale)]))
        sprite.zPosition = 3
        
        insertChild(sprite, atIndex: 0)
    }
    
    func wakeUp() {
        gameOver = true
        
        // Remove all the others
        for node in self.children {
            if node.isKindOfClass(SKShapeNode.self) {
                let circle = node as! SKShapeNode
                if let n = circle.name {
                    if n == "circle" {
                        circle.removeAllActions()
                    }
                    let scale0 = SKAction.scaleBy(0.8, duration: 0.1)
                    scale0.timingMode = SKActionTimingMode.EaseIn
                    let scale1 = SKAction.scaleBy(1.2, duration: 0.3)
                    scale1.timingMode = SKActionTimingMode.EaseOut
                    circle.runAction(SKAction.sequence([scale0, scale1]))
                }
            }
        }
        
        runAction(SKAction.playSoundFileNamed("suckback.caf", waitForCompletion: false))
        
        gameDelegate?.gameDidOver(Int64(ceil(gameDuration)))
    }
}
