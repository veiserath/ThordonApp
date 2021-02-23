//
//  ViewController.swift
//  ThordonApp
//
//  Created by Kacper Młodkowski on 03/09/2020.
//  Copyright © 2020 Kacper Młodkowski. All rights reserved.
//

import UIKit
import Socket
import Foundation


class NewCalculationViewController: UIViewController, StreamDelegate {
    
    
    var imageData = Data()
    
    @IBOutlet weak var inputValueTextField: UITextField!
    
    
    
    @IBAction func reloadPhoto(_ sender: Any) {
        
        print(inputValueTextField.text!)
        
        self.networkManager.createSocket()
        self.networkManager.connect()
        
        getInitialWindow()
        
//        print(jsonString.count * MemoryLayout.stride(ofValue: jsonString))

        downloadImage()
        
        self.networkManager.closeSocket()
        
    }
    struct Message: Codable {
        var command: String
        var x: String
        var y: String
        var userId: String
        var direction: String
    }
    
    
    let networkManager = NetworkManager()
    var touchPosition: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Calculation"
    }
    
    @IBOutlet weak var imageRead: UIImageView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            
            if inputValueTextField.text != "" {
                self.networkManager.createSocket()
                self.networkManager.connect()
                
                let position = touch.location(in: imageRead)
                let positionX = Int(position.x)
                let positionY = Int(position.y)
                let positionToPrint = "X: \(positionX) Y: \(positionY)"
                print(positionToPrint)
                let positionInJSON = Message(command: "fill:\(inputValueTextField.text!)", x: "\(positionX)", y: "\(positionY)", userId: "123", direction: "iOS")
                let jsonData = try! JSONEncoder().encode(positionInJSON)
                let jsonString = String(data: jsonData, encoding: .utf8)!
                
                
                let jsonLength = UInt32(jsonString.count)
                
                let array = withUnsafeBytes(of: jsonLength.bigEndian, Array.init)
            
                let lengthAsData = Data.init(bytes: array, count: 4)
                self.networkManager.send(data: lengthAsData)
                self.networkManager.send(message: jsonString)
                downloadImage()
                
                
                self.networkManager.closeSocket()
            } else {
                self.networkManager.createSocket()
                self.networkManager.connect()
                
                let position = touch.location(in: imageRead)
                let positionX = Int(position.x)
                let positionY = Int(position.y)
                let positionToPrint = "X: \(positionX) Y: \(positionY)"
                print(positionToPrint)
                let positionInJSON = Message(command: "click", x: "\(positionX)", y: "\(positionY)", userId: "123", direction: "iOS")
                let jsonData = try! JSONEncoder().encode(positionInJSON)
                let jsonString = String(data: jsonData, encoding: .utf8)!
                
                
                let jsonLength = UInt32(jsonString.count)
                
                let array = withUnsafeBytes(of: jsonLength.bigEndian, Array.init)
            
                let lengthAsData = Data.init(bytes: array, count: 4)
                self.networkManager.send(data: lengthAsData)
                self.networkManager.send(message: jsonString)
                downloadImage()
                
                
                self.networkManager.closeSocket()
            }
            
            
            
            
        }
    }
    
    func decodeImage(from: Data){
        print("Kiedy tworze foto, data ma wielkosc: \(from.count)\n"  )
        let imageCreated = UIImage(data: from)
        imageRead.image = imageCreated
    }
    
    func getInitialWindow() {
        print("Initiating initial window for Thordon App")
        
        let user = Message(command: "send_view", x: "-1", y: "-1", userId: "123", direction: "iOS")
        let jsonData = try! JSONEncoder().encode(user)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        
        let jsonLength = UInt32(jsonString.count)
        let array = withUnsafeBytes(of: jsonLength.bigEndian, Array.init)
    
        let lengthAsData = Data.init(bytes: array, count: 4)
        self.networkManager.send(data: lengthAsData)
        
        self.networkManager.send(message: jsonString)
    }
    
    func downloadImage() {
        let imageBufferSize = self.networkManager.readData()
        let bytesArray = ([UInt8])(imageBufferSize)
        let data = Data(_: bytesArray)
        let bufferSizeInteger = UInt32(bigEndian: data.withUnsafeBytes { $0.pointee })
        print(bufferSizeInteger)
        print("Bytesarray ma length: \(bytesArray.count)" )
        print(bytesArray)
        
    
        
        self.imageData = self.networkManager.readImage(expectedSize: Int(bufferSizeInteger))
        print("odebralem: \(imageData.count)")
        
        print("Po parsie: \([UInt8](imageData).count)")
        
        self.decodeImage(from: imageData)
    }
    
    
}
