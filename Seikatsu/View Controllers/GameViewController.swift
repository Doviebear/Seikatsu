//
//  GameViewController.swift
//  Seikatsu
//
//  Created by Dovie Shalev on 7/15/19.
//  Copyright © 2019 Dovie Shalev. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import Alamofire


class GameViewController: UIViewController {
    
  
    var url = URL(string: "http://127.0.0.1:2567/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request("http://127.0.0.1:2567/").responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
        
        
       
        
       
        JKGame.game.setOrientation(JKOrientation.landscape)
        
        
        let sceneNode = GameScene()
        sceneNode.size = JKGame.size
        sceneNode.scaleMode = .aspectFill
                
        // Present the scene
        if let view = self.view as! SKView? {
            view.presentScene(sceneNode)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
            
        
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
   
}


/*
 HTTP GET request without Starscream
 
 let url = URL(string: "http://127.0.0.1:2567/")!
 
 let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
 if let error = error {
 print("error: \(error)")
 } else {
 if let response = response as? HTTPURLResponse {
 print("statusCode: \(response.statusCode)")
 }
 if let data = data, let dataString = String(data: data, encoding: .utf8) {
 print("data: \(dataString)")
 }
 }
 }
 task.resume()
 
 */
