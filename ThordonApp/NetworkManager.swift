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
//            try mySocket?.setBlocking(mode: true)
        }
        catch {
            print("didn't create the socket")
        }
    }
    
    func connect(){
        do {
            // try mySocket!.connect(to: "25.94.234.108", port: 2137)
            try mySocket!.connect(to: "192.168.1.6", port: 997)
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
    func readData() -> Data {
        var receivedData = Data.init()
        do {
            try mySocket?.read(into: &receivedData)
        }
        catch {
            print("Error receiving data")
        }
        return receivedData
    }
    func readImage(sizeOfBuffer: UInt32) -> Data {
        var receivedData = Data.init(capacity: Int(sizeOfBuffer))
        do {
            try mySocket?.read(into: &receivedData)
        }
        catch {
            print("Error receiving data")
        }
        return receivedData
    }
    func naszaMetodaZwracajacaData(expectedSize: Int) -> Data {
        var sum = 0
        var receivedData = Data.init()
        var buffer = Data.init()
        while (sum != expectedSize) {
            do {
                if let x = try mySocket?.read(into: &receivedData) {
                    print("chunki junkie: \(x)")
                    if x <= 0 {
                        break
                    }
                    else {
                       sum += x
                    }
                } else {
                    break
                }
            }
            catch {
                print("Doooopa")
                break
            }
        }
        do {
            try mySocket?.write(from: "OK")
        } catch {
            print("Didnt send confirmation")
        }
        return receivedData
    }
    func sendMessage(message:String){
        do {
            //            connect()
            try self.mySocket?.write(from: message)
        }
        catch {
            print("didn't send the message")
        }
        
    }
    func closeSocket(){
        mySocket?.close()
    }
}
