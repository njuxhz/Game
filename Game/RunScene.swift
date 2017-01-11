//
//  RunView.swift
//  Game
//
//  Created by nju on 17/1/9.
//  Copyright (c) 2017年 njuxhz. All rights reserved.
//

import SpriteKit
import AVFoundation

class RunScene: SKScene {
    var bgmPlayer = AVAudioPlayer()
    var skinStr: String?
    var gS: GameScene?
    lazy var heroPic: String? = {
        var picStr: String?
        if(self.gS?.skinStr == nil){
            picStr = "human"
        } else {
            let str = self.gS?.skinStr!
            switch str!{
            case "red" : picStr = "human_red"
            case "oringe" : picStr = "human_oringe"
            case "origin" : picStr = "human"
            default:break
            }
        }
        return picStr
    }()
    
    init(gameScene: GameScene){
        super.init(size: gameScene.size)
        gS = gameScene
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private struct Constant {
        static let myYScale = CGFloat(Float(4.0))
        static let ground = SKSpriteNode(imageNamed: "Ground")
        static let sky = SKSpriteNode(imageNamed: "Skyline")
    }
    
    var hero: SKSpriteNode!
    var result: SKLabelNode!
    var obstacles: NSMutableArray = []
    var goldens: NSMutableArray = []
    var lose = false
    var startDate: NSDate!
    var addScore = 0
    
    private func showPic(picName: String, base: CGFloat) {
        let Pic = SKTexture(imageNamed: picName)
        Pic.filteringMode = SKTextureFilteringMode.Nearest
        let Spread = Range(start: 0, end: Int(50 + self.frame.size.width / Pic.size().width))
        let move = SKAction.moveByX(-8 * Pic.size().width * Constant.myYScale, y: 0.0,
            duration: Double(0.1 * Pic.size().width * Constant.myYScale))
        let reset = SKAction.moveByX(8 * Pic.size().width * Constant.myYScale, y: 0.0, duration: 0)
        for i in Spread.startIndex ... Spread.endIndex {
            let sprite = SKSpriteNode(imageNamed: picName)
            sprite.xScale = 1.0
            sprite.yScale = Constant.myYScale
            sprite.position = CGPointMake(sprite.size.width * CGFloat(Float(i) + 0.5),
                base + sprite.size.height / 2)
            sprite.runAction(SKAction.repeatActionForever(SKAction.sequence([move, reset])))
            self.addChild(sprite)
        }
    }
    
    func paveBackground(){
        lose = false
        startDate = NSDate()
        addScore = 0
        
        self.physicsWorld.gravity = CGVectorMake(0.0, -5.0)
        self.backgroundColor = UIColor(red: 113.0/255.0, green: 197.0/255.0, blue: 207.0/255.0, alpha: 1.0)
        
        showPic("Ground", base: 0)
        showPic("Skyline", base: Constant.ground.size.height * Constant.myYScale)
        
        if(heroPic != nil){
            hero = SKSpriteNode(imageNamed: heroPic!)
        }
        hero.xScale = 0.3
        hero.yScale = 0.3
        hero.position = CGPointMake(hero.size.width / 2, size.height / 2)
        hero.physicsBody = SKPhysicsBody(circleOfRadius: hero.size.height / 2)
        hero.physicsBody?.dynamic = true
        hero.physicsBody?.allowsRotation = false
        self.addChild(hero)
        
        obstacles = []
        
        var bgmPath:NSURL = NSBundle.mainBundle().URLForResource("music_dubstep", withExtension: "mp3")!
        bgmPlayer = AVAudioPlayer(contentsOfURL: bgmPath, error: nil)
        bgmPlayer.numberOfLoops = -1
        bgmPlayer.play()
        
        result = SKLabelNode(fontNamed: "Chalkduster")
        result.text = "0 s"
        result.name = "result"
        result.fontSize = 50
        result.fontColor = SKColor.blackColor()
        result.position = CGPointMake(self.frame.size.width / 2,
            Constant.ground.size.height * Constant.myYScale * 0.8 / 2)
        self.addChild(result)
    }
    
    func addTerritory(){
        let pic = SKSpriteNode(imageNamed: "Ground")
        var groundWall = SKNode()
        groundWall.position = CGPointMake(0, pic.size.height * Constant.myYScale / 2)
        groundWall.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width,
            pic.size.height * Constant.myYScale))
        groundWall.physicsBody?.dynamic = false
        self.addChild(groundWall)
        
        var skyWall = SKNode()
        skyWall.position = CGPointMake(0, self.frame.height + hero.size.height / 2)
        skyWall.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width,
            hero.size.height))
        skyWall.physicsBody?.dynamic = false
        self.addChild(skyWall)
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        paveBackground()
        
        addTerritory()
        
        var addObs = SKAction.runBlock({self.addObstacle()})
        var waitForNext = SKAction.waitForDuration(Double(4))
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([addObs, waitForNext])))
        
        var addGoldens = SKAction.runBlock({self.addGolden()})
        var waitForNextGoldens = SKAction.waitForDuration(Double(2))
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([addGoldens, waitForNextGoldens])))
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        hero.physicsBody?.velocity = CGVectorMake(0.0, 0.0)
        hero.physicsBody?.applyImpulse(CGVectorMake(0.0, 40.0))
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        var removesGoldens: NSMutableArray = []
        for golden in goldens{
            if(CGRectIntersectsRect(hero.frame, golden.frame)){
                removesGoldens.addObject(golden)
                addScore += 3
                
                var bonus = SKSpriteNode(imageNamed: "bonus")
                bonus.xScale = 0.7
                bonus.yScale = 0.7
                bonus.position = CGPointMake(CGRectGetMidX(golden.frame), CGRectGetMidY(golden.frame))
                self.addChild(bonus)
                let zoom = SKAction.scaleTo(1.5, duration: 1)
                let done = SKAction.runBlock({
                    bonus.removeFromParent()
                })
                bonus.runAction(SKAction.sequence([zoom, done]))
            }
        }
        for golden in removesGoldens{
            goldens.removeObject(golden)
            golden.removeFromParent()
        }
        
        var nowDate = NSDate()
        let seconds = nowDate.timeIntervalSinceDate(startDate)
        let sec = Int(round(seconds)) + addScore
        result.text = String(sec) + "s"
        let bios = 2
        
        var removes: NSMutableArray = []
        for obs in obstacles{
            if(CGRectGetMidX(self.frame) < ((-self.frame.size.width / 2) + CGFloat(Float(bios)))){
                removes.addObject(obs)
            }
        }
        for obs in removes{
            obstacles.removeObject(obs)
            obs.removeFromParent()
        }
        for obs in obstacles{
            if(CGRectIntersectsRect(hero.frame, obs.frame)){
                lose = true
                break
            }
        }
        
        if(lose){
            hero.removeAllActions()
            hero.physicsBody?.velocity = CGVectorMake(0.0, 0.0)
            self.physicsWorld.gravity = CGVectorMake(0.0, -5.0)
            for obs in obstacles{
                obs.removeAllActions()
            }
            let pause = SKAction.waitForDuration(0.25)
            let fadeAway = SKAction.fadeOutWithDuration(0.25)
            let moveSequence = SKAction.sequence([pause, fadeAway])
            self.runAction(moveSequence, completion: {
                self.bgmPlayer.pause()
                let result = ResultScene(gameScene: self.gS!, score: self.result.text)
                let doors = SKTransition.doorsOpenVerticalWithDuration(0.25)
                self.view?.presentScene(result, transition: doors)
            })
        }
    }
    
    func addObstacle(){
        var scale = CGFloat(Float(Float(arc4random_uniform(3) + 5) / 10))
        var durationTime = arc4random_uniform(2) + 1
        
        var color = arc4random_uniform(3)
        var obstacle = SKSpriteNode()
        switch(color){
        case 0: obstacle = SKSpriteNode(imageNamed: "light_red")
        case 1: obstacle = SKSpriteNode(imageNamed: "light_blue")
        case 2: obstacle = SKSpriteNode(imageNamed: "light_oringe")
        default:break
        }
        obstacle.xScale = scale
        obstacle.yScale = scale
        
        var yValue = arc4random_uniform(UInt32(self.frame.height - Constant.ground.size.height * Constant.myYScale)) + UInt32(Constant.ground.size.height * Constant.myYScale)
        var y = CGFloat(UInt32(yValue))
        obstacle.position = CGPointMake(self.frame.width + obstacle.size.width / 2, y)
        self.addChild(obstacle)
        let move = SKAction.moveTo(CGPointMake(0, y), duration: Double(12))
        let movedone = SKAction.runBlock({
            self.obstacles.removeObject(obstacle)
            obstacle.removeFromParent()
        })
        let rotation = SKAction.rotateByAngle(CGFloat(Float(180)), duration: Double(durationTime))
        obstacle.runAction(SKAction.repeatActionForever(SKAction.sequence([rotation])))
        obstacle.runAction(SKAction.sequence([move, movedone]))
        
        obstacles.addObject(obstacle)
    }
    
    func addGolden() {
        var durationTime: NSTimeInterval = 0.5
        let goldenTexture1 = SKTexture(imageNamed: "golden_1")
        goldenTexture1.filteringMode = .Nearest
        let goldenTexture2 = SKTexture(imageNamed: "golden_2")
        goldenTexture2.filteringMode = .Nearest
        let animation = SKAction.animateWithTextures([goldenTexture1, goldenTexture2], timePerFrame: durationTime)
        let flip = SKAction.repeatActionForever(animation)
        
        var scale = CGFloat(Float(1))
        var golden = SKSpriteNode(texture: goldenTexture1)
        golden.xScale = scale
        golden.yScale = scale
        self.addChild(golden)
        
        var yValue = arc4random_uniform(UInt32(self.frame.height - Constant.ground.size.height * Constant.myYScale))
            + UInt32(Constant.ground.size.height * Constant.myYScale * CGFloat(Float(1.2)))
        var y = CGFloat(UInt32(yValue))
        golden.position = CGPointMake(self.frame.width + golden.size.width / 2, y)
        let move = SKAction.moveTo(CGPointMake(0, y), duration: Double(12))
        let movedone = SKAction.runBlock({
            self.goldens.removeObject(golden)
            golden.removeFromParent()
        })
        golden.runAction(flip)
        golden.runAction(SKAction.sequence([move, movedone]))
        
        goldens.addObject(golden)
    }
}

