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
            try mySocket?.connect(to: "25.91.167.236",port: 2137)
        }
        catch {
            print("didn't connect")
        }
    }
    func readBufferSize() -> Data {
        var receivedData = Data.init()
        do {
            _ = try mySocket?.read(into: &receivedData)
        }
        catch {
            print("Error receiving data")
        }
        return receivedData
    }
    func readLosslessData(expectedSize: Int) -> Data {
        var sum = 0
        var receivedData = Data.init()
        while (sum != expectedSize) {
            do {
                if let x = try mySocket?.read(into: &receivedData) {
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
                print("Error reading junks")
                break
            }
        }
        do {
            try mySocket?.write(from: "OK")
        } catch {
            print("Didnt send OK")
        }
        return receivedData
    }
    
    func send(message:String){
        let message = "\(message)\r\n"
        let data = Data(message.utf8)
        do {
            try self.mySocket?.write(from: data)
        }
        catch {
            print("didn't send the message")
        }
    }
    func send(data:Data){
        do {
            try self.mySocket?.write(from: data)
        }
        catch {
            print("didn't send the message")
        }
    }
    func closeSocket(){
        mySocket?.close()
    }
}
