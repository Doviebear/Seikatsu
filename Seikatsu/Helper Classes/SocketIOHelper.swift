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
    
    let manager = SocketManager(socketURL: URL(string: "http://192.168.1.187:3003")!, config: [.log(true), .compress])
    var socket: SocketIOClient!
    var viewController: UIViewController?
    
    
   
   
    
    
    func createConnection() {
        socket = manager.defaultSocket
        socket.connect()
        self.setSocketEvents()
        
        
    }
    
    func searchForMatch() {
        
    }
    
    func disconnect() {
        socket.disconnect()
    }
    
    func sendData() {
        socket.emit("joinQueue")
        print("emitted message")
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
    
    func giveRandomizedModel() {
        
    }
    
    func setSocketEvents(){
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        socket.on(clientEvent: .disconnect) {data, ack in
            print("socket Disconnected")
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
                let gameScene = GameSceneOnline(gameModel: model, player: playerNum)
                gameScene.scaleMode = .aspectFill
                view.showsFPS = true
                view.showsNodeCount = true
                view.presentScene(gameScene, transition: .flipHorizontal(withDuration: 0.5))
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
    }
    
}

extension Notification.Name {
    static let turnStart = Notification.Name(rawValue: "turnStart")
    static let roundEnd = Notification.Name(rawValue: "roundEnd")
}
