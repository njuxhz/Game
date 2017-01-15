//
//  GameViewController.swift
//  Game
//
//  Created by nju on 17/1/4.
//  Copyright (c) 2017年 njuxhz. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit

extension SKNode {
    class func unarchiveFromFile(_ file : String) -> SKNode? {
        if let path = Bundle.main.path(forResource: file, ofType: "sks") {
            //var sceneData = Data(bytesNoCopy: path, count: .DataReadingMappedIfSafe, deallocator: nil)!
            //let sceneData = try! NSData(contentsOfFile:path, optins: .DataReadingMappedIfSafe)
            do{
                var sceneData = try NSData(contentsOfFile:path, options: .mappedIfSafe) as Data
                var archiver = NSKeyedUnarchiver(forReadingWith: sceneData)
                
                archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
                let scene = archiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as! GameScene
                archiver.finishDecoding()
                return scene
            }catch{
            }
            //var sceneData = NSData.dataWithContentsOfFile
        } else {
            return nil
        }
        return nil
    }
}

class GameViewController: UIViewController, sceneDelegate {
    var skinString: String?
    var notification: NotificationCenter?
    
    func showOtherView() {
        //var controller = MoreViewController()
        //self.navigationController?.pushViewController(controller, animated: true)
        self.performSegue(withIdentifier: "skin", sender: self)
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
            scene.scaleMode = .aspectFill
            
            scene.delegat = self
            scene.skinStr = skinString
            notification = NotificationCenter.default
            notification!.addObserver(self, selector: #selector(GameViewController.handleChangeSkin(_:)), name: NSNotification.Name(rawValue: "changeSkin"), object: nil)
            
            skView.presentScene(scene)
        }
    }

    func handleChangeSkin(_ notification: Notification){
        if let data: NSDictionary = notification.userInfo as NSDictionary?{
            let mode: NSString = data.object(forKey: "changeSkinMode")! as! NSString
            skinString = String(mode)
        }
    }
    
    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations:UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.all
    }
    
//    override func supportedInterfaceOrientations() -> Int {
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            return Int(UIInterfaceOrientationMask.allButUpsideDown.rawValue)
//        } else {
//            return Int(UIInterfaceOrientationMask.all.rawValue)
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
        if(notification != nil){
            notification?.removeObserver(self)
        }
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
}
