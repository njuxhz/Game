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
    
    @IBAction func changeSkin(_ sender: UIButton) {
        let color = sender.titleLabel?.text
        setToBlue()
        sender.setTitleColor(UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0), for: UIControlState())
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
        red.setTitleColor(UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0), for: UIControlState())
        oringe.setTitleColor(UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0), for: UIControlState())
        origin.setTitleColor(UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0), for: UIControlState())
    }
    
    @IBAction func backToScene(_ sender: UIButton) {
        if(self.skinMode != 0){
            var data: NSDictionary?
            switch skinMode {
            case 1 : data = NSDictionary(objects: ["red"], forKeys: ["changeSkinMode" as NSCopying])
            case 2 : data = NSDictionary(objects: ["oringe"], forKeys: ["changeSkinMode" as NSCopying])
            case 3 : data = NSDictionary(objects: ["origin"], forKeys: ["changeSkinMode" as NSCopying])
            default: break
            }
            let notification = NotificationCenter.default
            notification.post(name: Notification.Name(rawValue: "changeSkin"), object: self, userInfo: data as! [NSObject : NSString])
        }
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
