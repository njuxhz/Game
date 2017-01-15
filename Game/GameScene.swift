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
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        var start = SKLabelNode(fontNamed: "Chalkduster")
        start.text = "Start"
        start.name = "Start"
        start.fontSize = 50
        start.fontColor = SKColor.black
        start.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(start)
        
        var Skin = SKLabelNode(fontNamed: "Chalkduster")
        Skin.text = "Change Skin"
        Skin.name = "Change Skin"
        Skin.fontSize = 50
        Skin.fontColor = SKColor.black
        Skin.position = CGPoint(x: start.position.x, y: start.position.y * 0.8)
        self.addChild(Skin)
        
        var bgmPath:URL = Bundle.main.url(forResource: "background-music-aac", withExtension: "caf")!
        do {
            bgmPlayer = try AVAudioPlayer(contentsOf: bgmPath)
            bgmPlayer.numberOfLoops = -1
            bgmPlayer.play()
        } catch {
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        if let touch = touches.first {
            let location = touch.location(in: self)
            let node = self.atPoint(location)
            let zoom = SKAction.scale(to: 2.0, duration: 0.5)
            let pause = SKAction.wait(forDuration: 0.5)
            let fadeAway = SKAction.fadeOut(withDuration: 0.5)
            let moveSequence = SKAction.sequence([zoom, pause, fadeAway])
            if let str = node.name {
                switch str{
                case "Start":
                    self.skinStr = delegat?.getSkinStr()
                    let start = self.childNode(withName: "Start")
                    start?.run(moveSequence, completion: {
                        self.bgmPlayer.pause()
                        let runScene = RunScene(gameScene: self)
                        let doors = SKTransition.doorsOpenVertical(withDuration: 0.5)
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
        super.touchesBegan(touches, with: event)
    }
   
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
    
}
