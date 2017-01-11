//
//  GameScene.swift
//  Game
//
//  Created by nju on 17/1/4.
//  Copyright (c) 2017年 njuxhz. All rights reserved.
//

import SpriteKit
import AVFoundation
import UIKit

protocol sceneDelegate: NSObjectProtocol{
    func showOtherView()
    func getSkinStr() -> String?
}

class GameScene: SKScene {
    var delegat: sceneDelegate?
    var skinStr: String?
    
    var bgmPlayer = AVAudioPlayer()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        var start = SKLabelNode(fontNamed: "Chalkduster")
        start.text = "Start"
        start.name = "Start"
        start.fontSize = 50
        start.fontColor = SKColor.blackColor()
        start.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.addChild(start)
        
        var Skin = SKLabelNode(fontNamed: "Chalkduster")
        Skin.text = "Change Skin"
        Skin.name = "Change Skin"
        Skin.fontSize = 50
        Skin.fontColor = SKColor.blackColor()
        Skin.position = CGPointMake(start.position.x, start.position.y * 0.8)
        self.addChild(Skin)
        
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
                case "Start":
                    self.skinStr = delegat?.getSkinStr()
                    let start = self.childNodeWithName("Start")
                    start?.runAction(moveSequence, completion: {
                        self.bgmPlayer.pause()
                        let runScene = RunScene(gameScene: self)
                        let doors = SKTransition.doorsOpenVerticalWithDuration(0.5)
                        self.view?.presentScene(runScene, transition: doors)
                    })
                case "Change Skin":
                    if (delegat != nil) {
                        delegat?.showOtherView()
                    }
                default: break
                }
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
}
