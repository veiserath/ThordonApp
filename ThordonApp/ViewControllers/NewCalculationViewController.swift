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
    
    struct Message: Codable {
        var command: String
        var x: String
        var y: String
        var userId: String
        var direction: String
    }
    
    @IBOutlet weak var inputValueTextField: UITextField!
    @IBOutlet weak var imageRead: UIImageView!
    
    @IBOutlet weak var imageLoadingSpinner: UIActivityIndicatorView!
    
    
    let networkManager = NetworkManager()
    var touchPosition: String = ""
    
    var isReady = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Calculation"
        refreshView()
        
    }
    
    @IBAction func reloadPhoto(_ sender: Any) {
        self.refreshView()
    }
    
    func refreshView() {
        imageLoadingSpinner.hidesWhenStopped = true
        imageLoadingSpinner.startAnimating()
        
        self.networkManager.createSocket()
        self.networkManager.connect()
        
        let message = Message(command: "send_view", x: "-1", y: "-1", userId: "123", direction: "iOS")
        let jsonData = try! JSONEncoder().encode(message)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        
        let jsonLength = UInt32(jsonString.count)
        let array = withUnsafeBytes(of: jsonLength.bigEndian, Array.init)
        let lengthAsData = Data.init(bytes: array, count: 4)
        
        self.networkManager.send(data: lengthAsData)
        self.networkManager.send(message: jsonString)
        
        self.downloadImage()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
//        refreshView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            // switch case?
            if inputValueTextField.text != "" {
                self.fillData(touch: touch)
                inputValueTextField.text = ""
            } else {
                self.click(touch: touch)
            }
        }
    }
    
    func fillData(touch:UITouch) {
        self.networkManager.createSocket()
        self.networkManager.connect()
        
        let position = touch.location(in: imageRead)
        let positionX = Int(position.x)
        let positionY = Int(position.y)
        let positionInJSON = Message(command: "fill:\(inputValueTextField.text!)", x: "\(positionX)", y: "\(positionY)", userId: "123", direction: "iOS")
        
        let jsonData = try! JSONEncoder().encode(positionInJSON)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        
        
        let jsonLength = UInt32(jsonString.count)
        let array = withUnsafeBytes(of: jsonLength.bigEndian, Array.init)
        let lengthAsData = Data.init(bytes: array, count: 4)
        
        self.networkManager.send(data: lengthAsData)
        self.networkManager.send(message: jsonString)
        
        downloadImage()
    }
    
    func click(touch:UITouch) {
        self.networkManager.createSocket()
        self.networkManager.connect()
        
        let position = touch.location(in: imageRead)
        let positionX = Int(position.x)
        let positionY = Int(position.y)
        
        let positionInJSON = Message(command: "click", x: "\(positionX)", y: "\(positionY)", userId: "123", direction: "iOS")
        let jsonData = try! JSONEncoder().encode(positionInJSON)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        
        let jsonLength = UInt32(jsonString.count)
        let array = withUnsafeBytes(of: jsonLength.bigEndian, Array.init)
        let lengthAsData = Data.init(bytes: array, count: 4)
        
        self.networkManager.send(data: lengthAsData)
        self.networkManager.send(message: jsonString)

        downloadImage()
        
    }
    
    func downloadImage() {
        DispatchQueue.global(qos: .userInitiated).async {
            let imageBufferSize = self.networkManager.readBufferSize()
            let bytesArray = ([UInt8])(imageBufferSize)
            let data = Data(_: bytesArray)
            let bufferSizeInteger = data.withUnsafeBytes { $0.load(as: UInt32.self)}
            let imageData = self.networkManager.readLosslessData(expectedSize: Int(bufferSizeInteger))
            self.networkManager.closeSocket()
            DispatchQueue.main.async {
                self.imageLoadingSpinner.stopAnimating()
                self.setImage(from: imageData)
            }
        }
    }
    
    
    func setImage(from: Data){
        let imageCreated = UIImage(data: from)
        imageRead.image = imageCreated
    }
    
}
