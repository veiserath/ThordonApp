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
    
    
    var imageData = Data()
    
    @IBAction func reloadPhoto(_ sender: Any) {
        
        
        let user = Message(command: "send_view", x: "-1", y: "-1", userId: "123", direction: "iOS")
        let jsonData = try! JSONEncoder().encode(user)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        
        
        self.networkManager.createSocket()
        self.networkManager.connect()
        //        networkManager.sendMessage(message: jsonString)
        self.networkManager.sendMessage(message: "haha")
        
        var imageBufferSize = self.networkManager.readData()
        let bytesArray = ([UInt8])(imageBufferSize)
        let data = Data(_: bytesArray)
        let bufferSizeInteger = UInt32(bigEndian: data.withUnsafeBytes { $0.pointee })
        print(bufferSizeInteger)
        print("Bytesarray ma length: \(bytesArray.count)" )
        
        
//        self.imageData = self.networkManager.readImage(sizeOfBuffer: bufferSizeInteger)
        self.imageData = self.networkManager.naszaMetodaZwracajacaData(expectedSize: Int(bufferSizeInteger))
        print("odebralem: \(imageData.count)")
        
        print("Po parsie: \([UInt8](imageData).count)")
        
        self.decodeImage(from: imageData)
        self.networkManager.closeSocket()
        
        
        //            let imageData = self.networkManager.readImage(sizeOfBuffer: bufferSizeInteger)
        //            self.imageData = imageData
        //            self.decodeImage(from: self.imageData)
        //            print(imageData.count)
        
        
        
        
        
        
        
        
        
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
            let position = touch.location(in: imageRead)
            let positionX = Double(position.x)
            let positionY = Double(position.y)
            let positionToPrint = "X: \(positionX) Y: \(positionY)"
            print(positionToPrint)
        }
    }
    //    func decodeImage(imageAsString: String){
    //        let newImageData = Data(base64Encoded: imageAsString)
    //        if newImageData != nil {
    //            imageRead.image = UIImage(data: newImageData!)
    //        }
    //        else {
    //            print("Didn't receive any image")
    //        }
    //    }
    
    func decodeImage(from: Data){
        print("Kiedy tworze foto, data ma wielkosc: \(from.count)\n"  )
        let imageCreated = UIImage(data: from)
        imageRead.image = imageCreated
    }
    
    
}
