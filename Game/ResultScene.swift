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
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        var result = SKLabelNode(fontNamed: "Chalkduster")
        result.text = "You Score is: " + scoreStr!
        result.name = "You Lose!"
        result.fontSize = 50
        result.fontColor = SKColor.black
        result.position = CGPoint(x: self.frame.midX, y: self.frame.midY * 1.2)
        self.addChild(result)
        
        var again = SKLabelNode(fontNamed: "Chalkduster")
        again.text = "Try Again"
        again.name = "Try Again"
        again.fontSize = 50
        again.fontColor = SKColor.black
        again.position = CGPoint(x: result.position.x, y: result.position.y * 0.8)
        self.addChild(again)
        
        var back = SKLabelNode(fontNamed: "Chalkduster")
        back.text = "Back to Main"
        back.name = "Back to Main"
        back.fontSize = 50
        back.fontColor = SKColor.black
        back.position = CGPoint(x: result.position.x, y: result.position.y * 0.6)
        self.addChild(back)
        
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
                case "Try Again":
                    let again = self.childNode(withName: "Try Again")
                    again?.run(moveSequence, completion: {
                        self.bgmPlayer.pause()
                        let runScene = RunScene(gameScene: self.gS!)
                        let doors = SKTransition.doorsOpenVertical(withDuration: 0.5)
                        self.view?.presentScene(runScene, transition: doors)
                    })
                case "Back to Main":
                    let back = self.childNode(withName: "Back to Main")
                    back?.run(moveSequence, completion: {
                        self.bgmPlayer.pause()
                        let gameSceneController = GameViewController()
                        let doors = SKTransition.doorsOpenVertical(withDuration: 0.5)
                        self.view?.presentScene(self.gS!, transition: doors)
                    })
                default:break
                }
            }
        }
        super.touchesBegan(touches, with: event)
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
    
}
