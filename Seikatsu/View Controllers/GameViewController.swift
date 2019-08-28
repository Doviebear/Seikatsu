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
import SocketIO


class GameViewController: UIViewController {
    
    //AWS Server: http://3.218.33.203
    var url = URL(string: "http://3.218.33.203")
    var currentScene: SKScene? = nil
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SocketIOHelper.helper.viewController = self
        
        
        /*
        Alamofire.request(urlString!).responseJSON { response in
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
        */
        
        /*
        let manager = SocketManager(socketURL: URL(string: "http://127.0.0.1:3003")!, config: [.log(true), .compress])
        let socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        
       
        
        socket.connect()
        */
        
        SocketIOHelper.helper.createConnection()
       
        JKGame.game.setOrientation(JKOrientation.portrait)
        
       // let fullSKSName = checkIfSKSExists(baseSKSName: "MenuScene")
        // Present the scene
        if let view = self.view as! SKView? {
            
            let scene = MenuScene()
            scene.scaleMode = .aspectFill
            scene.size = JKGame.size
                
            view.presentScene(scene)
            
            
           
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
            self.currentScene = scene
            
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
   
    func checkIfSKSExists( baseSKSName:String) -> String {
        //We call this function with a baseSKSName passed in, and return either a
        //modified name or the same name if no other device specific SKS files are found.
        //For example, if baseSKSName = Level1 and Level1TV.sks exists in the project,
        //then the string returned is Level1TV
        
        var fullSKSNameToLoad:String = baseSKSName
            
        if ( UIDevice.current.userInterfaceIdiom == .pad) {
            
            if let _ = GameSceneOnline(fileNamed:  baseSKSName + "PadLand"){
                
                // this if statement would NOT be true if the iPad file did not exist
                
                fullSKSNameToLoad = baseSKSName + "PadLand"
            }
        } else if ( UIDevice.current.userInterfaceIdiom == .phone) {
            if let _ = GameSceneOnline(fileNamed:  baseSKSName + "PhonePortrait"){
                // this if statement would NOT be true if the Phone file did not exist
                fullSKSNameToLoad = baseSKSName + "PhonePortrait"
            }
        }
        //worry about TV later
        
        return fullSKSNameToLoad
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
       
        if let scene = self.currentScene as? GameSceneOnline {
            if UIDevice.current.orientation.isLandscape {
                print("GameSceneOnline is now in Landscape")
                scene.switchToLandscape()
            } else if UIDevice.current.orientation.isPortrait {
                print("GameSceneOnline is now in Portrait")
                scene.switchToPortrait()
            }
        } else if let scene = self.currentScene as? GameScene {
            if UIDevice.current.orientation.isLandscape {
                print("GameScene is now in landscape")
            } else if UIDevice.current.orientation.isPortrait {
                print("GameScene is now in Portrait")
            }
        } else if let scene = self.currentScene as? MenuScene {
            if UIDevice.current.orientation.isLandscape {
                print("MenuScene is now in Landscape")
            } else if UIDevice.current.orientation.isPortrait {
                print("MenuSceen is now in Portrait")
            }
        } else {
            return
        }
        
        
    }
}

extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
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
