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
    func endTurn() {
        
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
        }
        socket.on("hello") {data, ack in
            print("recieved hello message")
        }
        
    }
    
}
