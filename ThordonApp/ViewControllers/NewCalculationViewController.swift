//
//  ViewController.swift
//  ThordonApp
//
//  Created by Kacper Młodkowski on 03/09/2020.
//  Copyright © 2020 Kacper Młodkowski. All rights reserved.
//

import UIKit
import Socket


class NewCalculationViewController: UIViewController, StreamDelegate {
    
    
    struct Message: Codable {
        var command: String
        var x: String
        var y: String
        var userId: String
        var direction: String
    }
    
    
    let networkManager = NetworkManager()
    var touchPosition: String = ""
    
    @IBOutlet weak var imageRead: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "New Calculation"
        let user = Message(command: "send_view", x: "-1", y: "-1", userId: "123", direction: "iOS")
        let jsonData = try! JSONEncoder().encode(user)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        let messageSize: Int32 = Int32 (jsonString.count)
        let array = withUnsafeBytes(of: messageSize.bigEndian, Array.init)
        
        
        if let arrayAsString = String(bytes: array, encoding: .utf8) {
            print(array)
            print(arrayAsString)
            networkManager.createSocket()     //przy kazdym wejsciu na newcalculation
            networkManager.connect()
            networkManager.sendMessage(message: arrayAsString)
            networkManager.sendMessage(message: jsonString)
            if let sizeOfNextMessage = networkManager.receiveMessage() {
                print(sizeOfNextMessage)
            }
            if let receivedMessage = networkManager.receiveMessage() {
                decodeImage(imageAsString: receivedMessage)
            }
        } else {
            print("not a valid UTF-8 sequence")
        }
    
        networkManager.closeSocket()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: view)
            let positionX = Double(position.x)
            let positionY = Double(position.y)
            let positionToPrint = "X: \(positionX) Y: \(positionY)"
            print(position)
            networkManager.sendMessage(message: positionToPrint)
            if let sizeOfNextMessage = networkManager.receiveMessage() {
                print(sizeOfNextMessage)
            }
            if let receivedMessage = networkManager.receiveMessage() {
                decodeImage(imageAsString: receivedMessage)
            }
        }
    }
    func decodeImage(imageAsString: String){
        let newImageData = Data(base64Encoded: imageAsString)
        if newImageData != nil {
            imageRead.image = UIImage(data: newImageData!)
        }
        else {
            print("Didn't receive any image")
        }
    }
}
