//
//  ResultScene.swift
//  Game
//
//  Created by nju on 17/1/9.
//  Copyright (c) 2017年 njuxhz. All rights reserved.
//

import SpriteKit
import AVFoundation

class ResultScene: SKScene {
    var bgmPlayer = AVAudioPlayer()
    var gS: GameScene?
    var scoreStr: String?
    
    init(gameScene: GameScene, score: String){
        super.init(size: gameScene.size)
        gS = gameScene
        scoreStr = score
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        var result = SKLabelNode(fontNamed: "Chalkduster")
        result.text = "You Score is: " + scoreStr!
        result.name = "You Lose!"
        result.fontSize = 50
        result.fontColor = SKColor.blackColor()
        result.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) * 1.2)
        self.addChild(result)
        
        var again = SKLabelNode(fontNamed: "Chalkduster")
        again.text = "Try Again"
        again.name = "Try Again"
        again.fontSize = 50
        again.fontColor = SKColor.blackColor()
        again.position = CGPointMake(result.position.x, result.position.y * 0.8)
        self.addChild(again)
        
        var back = SKLabelNode(fontNamed: "Chalkduster")
        back.text = "Back to Main"
        back.name = "Back to Main"
        back.fontSize = 50
        back.fontColor = SKColor.blackColor()
        back.position = CGPointMake(result.position.x, result.position.y * 0.6)
        self.addChild(back)
        
        var bgmPath:NSURL = NSBundle.mainBundle().URLForResource("background-music-aac", withExtension: "caf")!
        bgmPlayer = AVAudioPlayer(contentsOfURL: bgmPath, error: nil)
        bgmPlayer.numberOfLoops = -1
        bgmPlayer.play()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        for touch:AnyObject in touches{
            var location = touch.locationInNode(self)
            var node = self.nodeAtPoint(location)
            let zoom = SKAction.scaleTo(2.0, duration: 0.5)
            let pause = SKAction.waitForDuration(0.5)
            let fadeAway = SKAction.fadeOutWithDuration(0.5)
            let moveSequence = SKAction.sequence([zoom, pause, fadeAway])
            if let str = node.name {
                switch str{
                case "Try Again":
                    let again = self.childNodeWithName("Try Again")
                    again?.runAction(moveSequence, completion: {
                        self.bgmPlayer.pause()
                        let runScene = RunScene(gameScene: self.gS!)
                        let doors = SKTransition.doorsOpenVerticalWithDuration(0.5)
                        self.view?.presentScene(runScene, transition: doors)
                    })
                case "Back to Main":
                    let back = self.childNodeWithName("Back to Main")
                    back?.runAction(moveSequence, completion: {
                        self.bgmPlayer.pause()
                        let gameSceneController = GameViewController()
                        let doors = SKTransition.doorsOpenVerticalWithDuration(0.5)
                        self.view?.presentScene(self.gS!, transition: doors)
                    })
                default:break
                }
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
}