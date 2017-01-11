//
//  MoreViewController.swift
//  Game
//
//  Created by nju on 17/1/9.
//  Copyright (c) 2017年 njuxhz. All rights reserved.
//

import Foundation
import UIKit

class SkinViewController: UIViewController {
    var skinMode = 0
    
    @IBOutlet weak var red: UIButton!
    @IBOutlet weak var oringe: UIButton!
    @IBOutlet weak var origin: UIButton!
    
    @IBAction func changeSkin(sender: UIButton) {
        var color = sender.titleLabel?.text
        setToBlue()
        sender.setTitleColor(UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0), forState: UIControlState.Normal)
        if(color != nil){
            switch color! {
            case "Red": skinMode = 1
            case "Oringe": skinMode = 2
            case "Origin": skinMode = 3
            default: break
            }
        }
    }
    
    func setToBlue(){
        red.setTitleColor(UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0), forState: UIControlState.Normal)
        oringe.setTitleColor(UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0), forState: UIControlState.Normal)
        origin.setTitleColor(UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0), forState: UIControlState.Normal)
    }
    
    @IBAction func backToScene(sender: UIButton) {
        if(self.skinMode != 0){
            var data: NSDictionary?
            switch skinMode {
            case 1 : data = NSDictionary(objects: ["red"], forKeys: ["changeSkinMode"])
            case 2 : data = NSDictionary(objects: ["oringe"], forKeys: ["changeSkinMode"])
            case 3 : data = NSDictionary(objects: ["origin"], forKeys: ["changeSkinMode"])
            default: break
            }
            var notification = NSNotificationCenter.defaultCenter()
            notification.postNotificationName("changeSkin", object: self, userInfo: data as! [NSObject : NSString])
        }
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}