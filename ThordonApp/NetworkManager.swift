//
//  BlueSocketTest.swift
//  ThordonApp
//
//  Created by Kacper Młodkowski on 06/10/2020.
//  Copyright © 2020 Kacper Młodkowski. All rights reserved.
//

import Foundation
import Socket

class NetworkManager: NSObject {
    
    var receivedMessage = ""
    var mySocket:Socket?
    
    func createSocket(){
        do {
            mySocket = try Socket.create()
        }
        catch {
            print("didn't create the socket")
        }
    }
    
    func connect(){
        do {
            try mySocket!.connect(to: "25.94.234.108", port: 2137)
            
        }
        catch {
            print("didn't connect")
        }
    }
    func receiveMessage() -> String? {
        do {
            receivedMessage = try mySocket!.readString()!
            return receivedMessage
        }
        catch {
            print("didn't receive message")
        }
        return nil
    }
    func sendMessage(message:String){
        do {
//            connect()
            try mySocket?.write(from: message)
        }
        catch {
            print("didn't send the message")
        }
        
    }
    func closeSocket(){
        mySocket?.close()
    }
}
