//
//  GameViewController.swift
//  Game
//
//  Created by nju on 17/1/4.
//  Copyright (c) 2017年 njuxhz. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController, sceneDelegate {
    var skinString: String?
    var notification: NSNotificationCenter?
    
    func showOtherView() {
        //var controller = MoreViewController()
        //self.navigationController?.pushViewController(controller, animated: true)
        self.performSegueWithIdentifier("skin", sender: self)
    }
    
    func getSkinStr() -> String?{
        return skinString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            scene.delegat = self
            scene.skinStr = skinString
            notification = NSNotificationCenter.defaultCenter()
            notification!.addObserver(self, selector: "handleChangeSkin:", name: "changeSkin", object: nil)
            
            skView.presentScene(scene)
        }
    }

    func handleChangeSkin(notification: NSNotification){
        if let data: NSDictionary = notification.userInfo{
            var mode: NSString = data.objectForKey("changeSkinMode")! as! NSString
            skinString = String(mode)
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
        if(notification != nil){
            notification?.removeObserver(self)
        }
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
