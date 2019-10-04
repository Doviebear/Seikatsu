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
            inspectDeviceOrientation()
            if let fileName = getFileName() {
                if let scene = MenuScene(fileNamed: fileName) {
                    scene.scaleMode = .aspectFill
                    
                    
                    view.presentScene(scene)
            
                    
                    view.ignoresSiblingOrder = true
                    view.showsFPS = true
                    view.showsNodeCount = true
                    self.currentScene = scene
                    
                } else {
                    print("Couldn't create Menu Scene")
                }
                
            } else {
                print("Couldn't get File Name for Menu Scene")
            }
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
   
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
       
        if let scene = self.currentScene as? GameSceneOnline {
            if UIDevice.current.orientation.isLandscape {
                print("GameSceneOnline is now in Landscape")
                scene.switchToLandscape()
            } else if UIDevice.current.orientation.isPortrait {
                print("GameSceneOnline is now in Portrait")
                scene.switchToPortrait()
            }
        } else if let scene = self.currentScene as? MenuScene {
            if UIDevice.current.orientation.isLandscape {
                scene.switchToLandscape()
                print("MenuScene is now in Landscape")
            } else if UIDevice.current.orientation.isPortrait {
                scene.switchToPortrait()
                print("MenuSceen is now in Portrait")
            }
        } else {
            return
        }
        
        
    }
    
    func getFileName() -> String? {
        //We call this function with a baseSKSName passed in, and return either a
        //modified name or the same name if no other device specific SKS files are found.
        //For example, if baseSKSName = Level1 and Level1TV.sks exists in the project,
        //then the string returned is Level1TV
        let baseSKSName = "MenuScene"
        var fullSKSNameToLoad:String
        if ( UIDevice.current.userInterfaceIdiom == .pad) {
            if UIDevice.current.orientation.isLandscape {
                if let _ = MenuScene(fileNamed:  baseSKSName + "PadLand"){
                    
                    // this if statement would NOT be true if the iPad file did not exist
                    
                    fullSKSNameToLoad = baseSKSName + "PadLand"
                } else {
                    return nil
                }
            } else if UIDevice.current.orientation.isPortrait {
                if let _ = MenuScene(fileNamed:  baseSKSName + "PadPortrait"){
                    
                    // this if statement would NOT be true if the iPad file did not exist
                    
                    fullSKSNameToLoad = baseSKSName + "PadPortrait"
                } else {
                    return nil
                }
            } else if UIDevice.current.orientation.isFlat {
                if let _ = MenuScene(fileNamed:  baseSKSName + "PadPortrait"){
                    
                    // this if statement would NOT be true if the iPad file did not exist
                    
                    fullSKSNameToLoad = baseSKSName + "PadPortrait"
                } else {
                    return nil
                }
            } else {
               fullSKSNameToLoad = baseSKSName + "PadPortrait"
            }
        } else if ( UIDevice.current.userInterfaceIdiom == .phone) {
            if UIDevice.current.orientation.isLandscape {
                if let _ = MenuScene(fileNamed:  baseSKSName + "PhoneLand"){
                    // this if statement would NOT be true if the Phone file did not exist
                    fullSKSNameToLoad = baseSKSName + "PhoneLand"
                } else {
                    return nil
                }
            } else if UIDevice.current.orientation.isPortrait {
                if let _ = MenuScene(fileNamed:  baseSKSName + "PhonePortrait"){
                    // this if statement would NOT be true if the Phone file did not exist
                    fullSKSNameToLoad = baseSKSName + "PhonePortrait"
                } else {
                    return nil
                }
            } else if UIDevice.current.orientation.isFlat {
                if let _ = MenuScene(fileNamed:  baseSKSName + "PhonePortrait"){
                    // this if statement would NOT be true if the Phone file did not exist
                    fullSKSNameToLoad = baseSKSName + "PhonePortrait"
                } else {
                    return nil
                }
            } else  {
                 fullSKSNameToLoad = baseSKSName + "PhonePortrait"
            }
            //worry about TV later
        } else {
            return nil
        }
        return fullSKSNameToLoad
    }
    
    func inspectDeviceOrientation() {
        let orientation = UIDevice.current.orientation
        switch UIDevice.current.orientation {
        case .portrait:
            print("portrait")
        case .landscapeLeft:
            print("landscapeLeft")
        case .landscapeRight:
            print("landscapeRight")
        case .portraitUpsideDown:
            print("portraitUpsideDown")
        case .faceUp:
            print("faceUp")
        case .faceDown:
            print("faceDown")
        default: // .unknown
            print("unknown")
        }
        if orientation.isPortrait { print("isPortrait") }
        if orientation.isLandscape { print("isLandscape") }
        if orientation.isFlat { print("isFlat") }
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
