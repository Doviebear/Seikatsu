//
//  SocketIOHelper.swift
//  Seikatsu
//
//  Created by Dovie Shalev on 8/6/19.
//  Copyright © 2019 Dovie Shalev. All rights reserved.
//

import Foundation
import SocketIO
import SpriteKit

class SocketIOHelper {
    static let helper = SocketIOHelper()
    
    //AWS Server: http://3.218.33.203/
    //Local Server: http://192.168.1.187:3003/
    let manager = SocketManager(socketURL: URL(string: "http://3.218.33.203/")!, config: [.log(true), .compress])
    var socket: SocketIOClient!
    var viewController: UIViewController?
    var uniqueID: String?
    
    
   
   
    
    
    func createConnection() {
        //manager.reconnects = true
        socket = manager.defaultSocket
        socket.connect()
        self.setSocketEvents()
        
       // NotificationCenter.default.addObserver(self, selector: #selector(tryToReconnect(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func tryToReconnect(_ notification: Notification) {
        manager.reconnect()
    }
    
    func searchForMatch() {
        socket.emitWithAck("joinQueue").timingOut(after: 3) { data in
            
            if let statusNum = data[0] as? Int {
                if statusNum == 0 {
                    NotificationCenter.default.post(name: .joinedQueue, object: nil)
                    //You are already in the queue
                } else if statusNum == 3 {
                    NotificationCenter.default.post(name: .alreadyInQueue, object: nil)
                }
            } else if let statusNum = data[0] as? String {
                if statusNum == SocketAckStatus.noAck.rawValue {
                    if SocketIOHelper.helper.socket.status != .connected {
                        NotificationCenter.default.post(name: .serverTimeout, object: nil)
                    } else {
                        self.searchForMatch()
                    }
                    print("Emit for searchForMatch Timed out")
                    return
                }
            
                
            } else {
                print("Couldn't typecast callback")
                return
            }
            //All good, entered into queue
            
        }
        print("emitted message to Join Queue")
    }
    
    func stopSearchForMatch(){
        socket.emitWithAck("removeFromQueue").timingOut(after: 3) { data in
            if let statusNum = data[0] as? Int {
                if statusNum == 0 {
                    //All good, left queue
                    NotificationCenter.default.post(name: .removedFromQueue, object: nil)
                } else if statusNum == 11 {
                    //You were never in the queue in the first place...
                }
            } else if let statusNum = data[0] as? String {
                if statusNum == SocketAckStatus.noAck.rawValue {
                    NotificationCenter.default.post(name: .serverTimeout, object: nil)
                    print("Emit for searchForMatch Timed out")
                    return
                }
            } else {
                print("Couldn't typecast callback")
                return
            }
        }
    }
    
    func disconnect() {
        socket.disconnect()
       
    }
    
    func endTurn(model: GameModel) {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(model)
            var arrayToSend = [Any]()
            arrayToSend.append(jsonData)
            socket.emit("turnEnded", with: arrayToSend)
        } catch {
            print("Unexpected error: \(error).")
        }
        
    }
    
    func endRound(model: GameModel) {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(model)
            var arrayToSend = [Any]()
            arrayToSend.append(jsonData)
            socket.emit("roundEnded", with: arrayToSend)
        } catch {
            print("Unexpected error: \(error).")
        }
    }
    
    func getNumInRoom() -> Int? {
        var numToReturn: Int?
        socket.emitWithAck("getNumInRoom").timingOut(after: 3) { data in
            if let numInRoom = data[0] as? Int {
                print("Num in room after emit is \(numInRoom)")
                numToReturn = numInRoom
            } else if let statusNum = data[0] as? String {
                if statusNum == SocketAckStatus.noAck.rawValue {
                    
                    NotificationCenter.default.post(name: .serverTimeout, object: nil)
                    
                    print("Emit for searchForMatch Timed out")
                    numToReturn = nil
                }
                
                
            } else {
                print("Couldn't typecast callback")
                numToReturn = nil
            }
            
        }
        //print("num To return is \(numToReturn)")
        return numToReturn
    }
    
    func quitMatch() {
        
    }
    
    func createGame(gameID: String) {
        var arrayToSend = [Any]()
        arrayToSend.append(gameID)
        socket.emitWithAck("createGame", with: arrayToSend).timingOut(after: 3) { data in
           if let statusNum = data[0] as? Int {
                if statusNum == 0 {
                    //All good, game joined
                    NotificationCenter.default.post(name: .returnText, object: gameID )
                } else if statusNum == 3 {
                    //Game Name Already Exists
                    NotificationCenter.default.post(name: .gameNameTaken, object: gameID )
                }
            } else if let statusNum = data[0] as? String {
                if statusNum == SocketAckStatus.noAck.rawValue {
                    NotificationCenter.default.post(name: .serverTimeout, object: nil)
                    print("Couldn't create Game")
                    return
                }
            
                
            } else {
                print("Couldn't typecast callback")
                return
            }
        }
    }
    
    func joinFriendGame(gameID: String) {
        var arrayToSend = [Any]()
        arrayToSend.append(gameID)
        socket.emitWithAck("joinRoom", with: arrayToSend).timingOut(after: 3) { data in
            if let statusNum = data[0] as? Int {
                if statusNum == 0 {
                    //All good, game joined
                    NotificationCenter.default.post(name: .returnText, object: gameID )
                } else if statusNum == 10 {
                    //Game Name Not Found
                    NotificationCenter.default.post(name: .gameNameTaken, object: gameID )
                } else if statusNum == 11 {
                    // Already three people in the room
                    NotificationCenter.default.post(name: .gameNameTaken, object: gameID )
                }
            } else if let statusNum = data[0] as? String {
                if statusNum == SocketAckStatus.noAck.rawValue {
                    NotificationCenter.default.post(name: .serverTimeout, object: nil)
                    print("Couldn't Join Game")
                    return
                }
                
                
            } else {
                print("Couldn't typecast callback")
                return
            }
        }
    }
    
    func startFriendGame(nameOfGame: String) {
        var arrayToSend = [Any]()
        arrayToSend.append(nameOfGame)
        socket.emit("startFriendGame", with: arrayToSend)
    }
    
    func setSocketEvents(){
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            if let id = self.uniqueID {
                var arrayToSend = [Any]()
                arrayToSend.append(id)
                self.socket.emit("reconnectionPing", with: arrayToSend)
            }
            NotificationCenter.default.post(name: .connectedToServer, object: nil)
            
        }
        socket.on(clientEvent: .disconnect) {data, ack in
            print("socket Disconnected")
            NotificationCenter.default.post(name: .disconnectedFromServer, object: nil)
        }
        socket.on(clientEvent: .statusChange) {data, ack in
            // Some status changing logging
        }
        socket.on(clientEvent: .reconnect) {data, ack in
            print("Socket reconnected")
            /*
            if let id = self.uniqueID {
                var arrayToSend = [Any]()
                arrayToSend.append(id)
                self.socket.emit("reconnection", with: arrayToSend)
            }
 */
        }
        socket.on("playerDisconnected") { data, ack in
            NotificationCenter.default.post(name: .playerDisconnected, object: nil)
            
        }
        socket.on("hereIsUniqueId") { data, ack in
            if self.uniqueID != nil {
                return
            }
            guard let id = data[0] as? String else {
                print("couldn't get String from data")
                return
            }
            self.uniqueID = id
        }
        
        socket.on("startGame") {data, ack in
            print("message recieved to start game")
            let model: GameModel
            
            guard let playerNum = data[1] as? Int else {
                print("couldn't get playerNum")
                return
            }
            
            
            guard let data = data[0] as? Data else {
                print("couldn't typecast data")
                return
            }
            
            
            //print("This is playerNum after decoding: \(playerNum)" )
 
            
            do {
                model = try JSONDecoder().decode(GameModel.self, from: data)
                print("decoded Model")
            } catch {
                print("Couldn't decode data from server")
                return
            }
            
            if let view = self.viewController!.view as! SKView? {
                print("chaning view")
                if let fileName = self.getFileName() {
                    print("The file name gotten is \(fileName)")
                    if let gameScene = GameSceneOnline(fileNamed: fileName, gameModel: model, player: playerNum) {
                        view.showsFPS = true
                        view.showsNodeCount = true
                        view.presentScene(gameScene, transition: .flipHorizontal(withDuration: 0.5))
                        
                        if let gameViewController = self.viewController as? GameViewController {
                            gameViewController.currentScene = gameScene
                        }
                    }
                } else {
                    print("Couldn't get File name")
                }
            } else {
                print("couldn't typecast view as SKView")
            }
        }
    
        socket.on("hello") {data, ack in
            print("recieved hello message")
        }
        socket.on("startTurn") {data, ack in
            print("message recieved to start turn")
            let model: GameModel
            
            guard let data = data[0] as? Data else {
                print("couldn't typecast data")
                return
            }
            
            do {
                model = try JSONDecoder().decode(GameModel.self, from: data)
                print("decoded Model")
            } catch {
                print("Couldn't decode data from server")
                return
            }
            
            NotificationCenter.default.post(name: .turnStart, object: model)
               
            
        }
        socket.on("endRound") {data, ack in
            print("message recieved to end round")
            let model: GameModel
            
            guard let data = data[0] as? Data else {
                print("couldn't typecast data")
                return
            }
            
            do {
                model = try JSONDecoder().decode(GameModel.self, from: data)
                print("decoded Model")
            } catch {
                print("Couldn't decode data from server")
                return
            }
            
            NotificationCenter.default.post(name: .roundEnd, object: model)
            
            
        }
        socket.on("getModel") {data, ack in
           print("Message recieved to get model")
            let model = GameModel()
            do {
                let jsonEncoder = JSONEncoder()
                let jsonData = try jsonEncoder.encode(model)
                var arrayToSend = [Any]()
                arrayToSend.append(jsonData)
                ack.with(arrayToSend)
            } catch {
                print("Unexpected error: \(error).")
            }
        }
        socket.on("updateFriendRoom") {data, ack in
            print("Message Recieved to Update Friend Room")
            guard let numInRoom = data[0] as? Int else {
                return
            }
            NotificationCenter.default.post(name: .updateFriendRoom, object: numInRoom)
            
        }
        
    }
    
    
    func getFileName() -> String? {
        //We call this function with a baseSKSName passed in, and return either a
        //modified name or the same name if no other device specific SKS files are found.
        //For example, if baseSKSName = Level1 and Level1TV.sks exists in the project,
        //then the string returned is Level1TV
        let baseSKSName = "GameSceneOnline"
        var fullSKSNameToLoad:String
        if ( UIDevice.current.userInterfaceIdiom == .pad) {
            if UIDevice.current.orientation.isLandscape {
                if let _ = GameSceneOnline(fileNamed:  baseSKSName + "PadLand"){
                    
                    // this if statement would NOT be true if the iPad file did not exist
                    
                    fullSKSNameToLoad = baseSKSName + "PadLand"
                } else {
                    return nil
                }
            } else if UIDevice.current.orientation.isPortrait {
                if let _ = GameSceneOnline(fileNamed:  baseSKSName + "PadPortrait"){
                    
                    // this if statement would NOT be true if the iPad file did not exist
                    
                    
                    fullSKSNameToLoad = baseSKSName + "PadPortrait"
                   
                } else {
                    return nil
                }
            } else if UIDevice.current.orientation.isFlat {
                if let _ = GameSceneOnline(fileNamed:  baseSKSName + "PadPortrait"){
                    
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
                if UIDevice.current.hasTopNotch {
                    if let _ = GameSceneOnline(fileNamed:  baseSKSName + "PhoneLand"){
                        // this if statement would NOT be true if the Phone file did not exist
                        fullSKSNameToLoad = baseSKSName + "PhoneLand"
                    } else {
                        return nil
                    }
                } else {
                    if let _ = GameSceneOnline(fileNamed:  baseSKSName + "NoNotchLand"){
                        // this if statement would NOT be true if the Phone file did not exist
                        fullSKSNameToLoad = baseSKSName + "NoNotchLand"
                    } else {
                        return nil
                    }
                    
                }
                
            } else if UIDevice.current.orientation.isPortrait || UIDevice.current.orientation.isFlat {
                if UIDevice.current.hasTopNotch {
                    if let _ = GameSceneOnline(fileNamed:  baseSKSName + "PhonePortrait"){
                        // this if statement would NOT be true if the Phone file did not exist
                        fullSKSNameToLoad = baseSKSName + "PhonePortrait"
                    } else {
                        return nil
                    }
                } else {
                    if let _ = GameSceneOnline(fileNamed:  baseSKSName + "NoNotchPortrait"){
                        // this if statement would NOT be true if the Phone file did not exist
                        fullSKSNameToLoad = baseSKSName + "NoNotchPortrait"
                    } else {
                        return nil
                    }
                }
            } else {
                return nil
            }
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

extension Notification.Name {
    static let turnStart = Notification.Name(rawValue: "turnStart")
    static let roundEnd = Notification.Name(rawValue: "roundEnd")
    static let joinedQueue = Notification.Name(rawValue: "joinedQueue")
    static let alreadyInQueue = Notification.Name(rawValue: "alreadyInQueue")
    static let connectedToServer = Notification.Name(rawValue: "connectedToServer")
    static let disconnectedFromServer = Notification.Name(rawValue: "disconnectedFromServer")
    static let showTextField = Notification.Name(rawValue: "showTextField")
    static let hideTextField = Notification.Name(rawValue: "hideTextField")
    static let returnText =  Notification.Name(rawValue: "returnText")
    static let gameNameTaken = Notification.Name(rawValue: "gameNameTaken")
    static let updateFriendRoom = Notification.Name(rawValue: "updateFriendRoom")
    static let playAgain = Notification.Name(rawValue: "playAgain")
    static let checkGameCode = Notification.Name(rawValue: "checkGameCode")
    static let playerDisconnected = Notification.Name(rawValue: "playerDisconnected")
    static let serverTimeout = Notification.Name(rawValue: "serverTimeout")
    static let removedFromQueue = Notification.Name(rawValue: "removedFromQueue")
    static let playSoloGameAgain = Notification.Name(rawValue: "playSoloGameAgain")
    static let muteAllMusic = Notification.Name(rawValue: "muteAll")
    static let unmuteAllMusic = Notification.Name(rawValue: "unmuteAll")
}
