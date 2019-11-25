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
import SocketIO


class GameViewController: UIViewController, UITextFieldDelegate {
    
    //AWS Server: http://3.218.33.203
    var currentScene: SKScene? = nil
    var playWithFriendsTextField : UITextField!
    var joiningOrCreatingGame: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SocketIOHelper.helper.viewController = self
        
        let textRect = CGRect(x: view.center.x, y: view.center.y, width: 300, height: 100)
        playWithFriendsTextField = UITextField(frame: textRect )
        playWithFriendsTextField.isHidden = true
        
        view.addSubview(playWithFriendsTextField)
        playWithFriendsTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(showTextField(_:)), name: .showTextField, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(hideTextField(_:)), name: .hideTextField, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gameNameTaken(_:)), name: .gameNameTaken, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(checkGameCode(_:)), name: .checkGameCode, object: nil)
        
        
        
       
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
                    scene.playIntroLogo = true
                    
                    view.presentScene(scene)
                    scene.playIntro()
            
                    
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
    
    @objc func showTextField(_ notification: Notification){
        
        guard let ArrayOfStuff = notification.object as? [Any] else {
            return
        }
        
        guard let positionOfField = ArrayOfStuff[0] as? CGPoint else {
            return
        }
        
        guard let typeOfTextField = ArrayOfStuff[1] as? String else {
            return
        }
        
        joiningOrCreatingGame = typeOfTextField
        
        
        playWithFriendsTextField.placeholder = "Game Code"
        playWithFriendsTextField.textColor = .gray
        playWithFriendsTextField.backgroundColor = .white
        var frame = self.playWithFriendsTextField.frame
        frame.origin.x = positionOfField.x - 75
        frame.origin.y = positionOfField.y
        frame.size = CGSize(width : 150, height: 25)
        playWithFriendsTextField.frame = frame
        
        
        playWithFriendsTextField.isHidden = false
        print("text Field Shown")
    }
    
    @objc func hideTextField(_ notification: Notification) {
        playWithFriendsTextField.isHidden = true
        playWithFriendsTextField.resignFirstResponder()
    }
    
    @objc func gameNameTaken(_ notification: Notification) {
        
    }
    
    @objc func checkGameCode(_ notification: Notification) {
        if let gameString = playWithFriendsTextField.text {
            if joiningOrCreatingGame == "joining" {
                SocketIOHelper.helper.joinFriendGame(gameID: gameString)
            } else {
                SocketIOHelper.helper.createGame(gameID: gameString)
            }
        } else {
            print("couldn't get Text from field")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        /*
        textField.resignFirstResponder()
        if let gameString = textField.text {
            print(joiningOrCreatingGame!)
            if joiningOrCreatingGame == "joining" {
                SocketIOHelper.helper.joinFriendGame(gameID: gameString)
            } else {
                SocketIOHelper.helper.createGame(gameID: gameString)
            }
            
            
            //Loading animation TODO
            return true
        } else {
            return false
        }
 */
        textField.resignFirstResponder()
        return true
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
