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
    
    fileprivate struct Constant {
        static let myYScale = CGFloat(Float(2.0))
        static let ground = SKSpriteNode(imageNamed: "Ground")
        static let sky = SKSpriteNode(imageNamed: "Skyline")
    }
    
    var hero: SKSpriteNode!
    var result: SKLabelNode!
    var obstacles: NSMutableArray = []
    var goldens: NSMutableArray = []
    var lose = false
    var startDate: Date!
    var addScore = 0
    var baseline: CGFloat?
    
    fileprivate func showPic(_ picName: String, base: CGFloat) {
        let Pic = SKTexture(imageNamed: picName)
        Pic.filteringMode = SKTextureFilteringMode.nearest
        let Spread = (0 ..< Int(50 + self.frame.size.width / Pic.size().width))
        let move = SKAction.moveBy(x: -8 * Pic.size().width * Constant.myYScale, y: 0.0,
            duration: Double(0.1 * Pic.size().width * Constant.myYScale))
        let reset = SKAction.moveBy(x: 8 * Pic.size().width * Constant.myYScale, y: 0.0, duration: 0)
        for i in Spread.lowerBound ... Spread.upperBound {
            let sprite = SKSpriteNode(imageNamed: picName)
            sprite.xScale = 1.0
            sprite.yScale = Constant.myYScale
            sprite.position = CGPoint(x: sprite.size.width * CGFloat(Float(i) + 0.5),
                y: base + sprite.size.height / 2)
            sprite.run(SKAction.repeatForever(SKAction.sequence([move, reset])))
            self.addChild(sprite)
        }
    }
    
    func paveBackground(){
        lose = false
        startDate = Date()
        addScore = 0
        
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
        self.backgroundColor = UIColor(red: 113.0/255.0, green: 197.0/255.0, blue: 207.0/255.0, alpha: 1.0)
        
        showPic("Ground", base: 0)
        showPic("Skyline", base: Constant.ground.size.height * Constant.myYScale)
        
        baseline = (Constant.ground.size.height + Constant.sky.size.height) * Constant.myYScale
        
        if(heroPic != nil){
            hero = SKSpriteNode(imageNamed: heroPic!)
        }
        hero.xScale = 0.3
        hero.yScale = 0.3
        hero.position = CGPoint(x: hero.size.width / 2, y: size.height / 2)
        hero.physicsBody = SKPhysicsBody(circleOfRadius: hero.size.height / 2)
        hero.physicsBody?.isDynamic = true
        hero.physicsBody?.allowsRotation = false
        self.addChild(hero)
        
        obstacles = []
        
        var bgmPath:URL = Bundle.main.url(forResource: "music_dubstep", withExtension: "mp3")!
        do {
            bgmPlayer = try AVAudioPlayer(contentsOf: bgmPath)
            bgmPlayer.numberOfLoops = -1
            bgmPlayer.play()
        } catch {
        }
        
        result = SKLabelNode(fontNamed: "Chalkduster")
        result.text = "0 s"
        result.name = "result"
        result.fontSize = 50
        result.fontColor = SKColor.black
        result.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height  - 50)
        self.addChild(result)
    }
    
    func addTerritory(){
        let pic = SKSpriteNode(imageNamed: "Ground")
        let groundWall = SKNode()
        groundWall.position = CGPoint(x: 0, y: baseline! - CGFloat(Float(50)))
        groundWall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width,
            height: pic.size.height * Constant.myYScale))
        groundWall.physicsBody?.isDynamic = false
        self.addChild(groundWall)
        
        let skyWall = SKNode()
        skyWall.position = CGPoint(x: 0, y: self.frame.height + hero.size.height / 2)
        skyWall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width,
            height: hero.size.height))
        skyWall.physicsBody?.isDynamic = false
        self.addChild(skyWall)
    }
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        paveBackground()
        
        addTerritory()
        
        let addObs = SKAction.run({self.addObstacle()})
        let waitForNext = SKAction.wait(forDuration: Double(4))
        self.run(SKAction.repeatForever(SKAction.sequence([addObs, waitForNext])))
        
        let addGoldens = SKAction.run({self.addGolden()})
        let waitForNextGoldens = SKAction.wait(forDuration: Double(2))
        self.run(SKAction.repeatForever(SKAction.sequence([addGoldens, waitForNextGoldens])))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        if let touch = touches.first {
            hero.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0)
            hero.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 40.0))
        }
        super.touchesBegan(touches, with: event)
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        let removesGoldens: NSMutableArray = []
        for golden in goldens{
            if(hero.frame.intersects((golden as AnyObject).frame)){
                removesGoldens.add(golden)
                addScore += 3
                
                let bonus = SKSpriteNode(imageNamed: "bonus")
                bonus.xScale = 0.7
                bonus.yScale = 0.7
                bonus.position = CGPoint(x: ((golden as AnyObject).frame).midX, y: ((golden as AnyObject).frame).midY)
                self.addChild(bonus)
                let zoom = SKAction.scale(to: 1.5, duration: 1)
                let done = SKAction.run({
                    bonus.removeFromParent()
                })
                bonus.run(SKAction.sequence([zoom, done]))
            }
        }
        for golden in removesGoldens{
            goldens.remove(golden)
            (golden as AnyObject).removeFromParent()
        }
        
        let nowDate = Date()
        let seconds = nowDate.timeIntervalSince(startDate)
        let sec = Int(round(seconds)) + addScore
        result.text = String(sec) + "s"
        let bios = 2
        
        let removes: NSMutableArray = []
        for obs in obstacles{
            if(self.frame.midX < ((-self.frame.size.width / 2) + CGFloat(Float(bios)))){
                removes.add(obs)
            }
        }
        for obs in removes{
            obstacles.remove(obs)
            (obs as AnyObject).removeFromParent()
        }
        for obs in obstacles{
            if(hero.frame.intersects((obs as AnyObject).frame)){
                lose = true
                break
            }
        }
        
        if(lose){
            hero.removeAllActions()
            hero.physicsBody?.velocity = CGVector(dx: 0.0, dy: 0.0)
            self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
            for obs in obstacles{
                (obs as AnyObject).removeAllActions()
            }
            let pause = SKAction.wait(forDuration: 0.25)
            let fadeAway = SKAction.fadeOut(withDuration: 0.25)
            let moveSequence = SKAction.sequence([pause, fadeAway])
            self.run(moveSequence, completion: {
                self.bgmPlayer.pause()
                let result = ResultScene(gameScene: self.gS!, score: self.result.text!)
                let doors = SKTransition.doorsOpenVertical(withDuration: 0.25)
                self.view?.presentScene(result, transition: doors)
            })
        }
    }
    
    func addObstacle(){
        let scale = CGFloat(Float(Float(arc4random_uniform(3) + 5) / 10))
        let durationTime = arc4random_uniform(2) + 1
        
        let color = arc4random_uniform(3)
        var obstacle = SKSpriteNode()
        switch(color){
        case 0: obstacle = SKSpriteNode(imageNamed: "light_red")
        case 1: obstacle = SKSpriteNode(imageNamed: "light_blue")
        case 2: obstacle = SKSpriteNode(imageNamed: "light_oringe")
        default:break
        }
        obstacle.xScale = scale
        obstacle.yScale = scale
        
        let yValue = arc4random_uniform(UInt32(self.frame.height - Constant.ground.size.height * Constant.myYScale))
            + UInt32(baseline!)
        let y = CGFloat(UInt32(yValue))
        obstacle.position = CGPoint(x: self.frame.width + obstacle.size.width / 2, y: y)
        self.addChild(obstacle)
        let move = SKAction.move(to: CGPoint(x: 0, y: y), duration: Double(12))
        let movedone = SKAction.run({
            self.obstacles.remove(obstacle)
            obstacle.removeFromParent()
        })
        let rotation = SKAction.rotate(byAngle: CGFloat(Float(180)), duration: Double(durationTime))
        obstacle.run(SKAction.repeatForever(SKAction.sequence([rotation])))
        obstacle.run(SKAction.sequence([move, movedone]))
        
        obstacles.add(obstacle)
    }
    
    func addGolden() {
        let durationTime: TimeInterval = 0.5
        let goldenTexture1 = SKTexture(imageNamed: "golden_1")
        goldenTexture1.filteringMode = .nearest
        let goldenTexture2 = SKTexture(imageNamed: "golden_2")
        goldenTexture2.filteringMode = .nearest
        let animation = SKAction.animate(with: [goldenTexture1, goldenTexture2], timePerFrame: durationTime)
        let flip = SKAction.repeatForever(animation)
        
        let scale = CGFloat(Float(1))
        let golden = SKSpriteNode(texture: goldenTexture1)
        golden.xScale = scale
        golden.yScale = scale
        self.addChild(golden)
        
        let yValue = arc4random_uniform(UInt32(self.frame.height - Constant.ground.size.height * Constant.myYScale))
            + UInt32(baseline!)
        let y = CGFloat(UInt32(yValue))
        golden.position = CGPoint(x: self.frame.width + golden.size.width / 2, y: y)
        let move = SKAction.move(to: CGPoint(x: 0, y: y), duration: Double(12))
        let movedone = SKAction.run({
            self.goldens.remove(golden)
            golden.removeFromParent()
        })
        golden.run(flip)
        golden.run(SKAction.sequence([move, movedone]))
        
        goldens.add(golden)
    }
}

