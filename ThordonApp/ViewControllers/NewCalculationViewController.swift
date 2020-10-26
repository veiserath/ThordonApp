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
    
    let networkManager = NetworkManager()
    var touchPosition: String = ""
    @IBOutlet weak var imageRead: UIImageView!
    

    let typeOfService = ["Marine Propeller Shaft","Rudder - Thordon Standard","Rudder - with 1.5 mm MIC","Hydro Wicket Gate & Linkage Bearings","Vertical Turbine Guide Bearing","Horizontal Turbine Guide Bearing","Ind. Vertical Pump","Ind. Vertical Pump - Dry Start","Ind. Other Full Rotation","Ind. Oscillating Rotation"]

//    for marine propeller shaft
    let gradeOfService = ["SXL","COMPAC","XL","RiverTough","GM2401 in Metal Carrier"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Calculation"
        networkManager.createSocket()
        networkManager.connect()
        networkManager.receiveMessage()
        networkManager.sendMessage(message: "Greetings from Swift")
//        networkManager.closeSocket()
        decodeImage()

        
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: view)
            let positionX = Double(position.x)
            let positionY = Double(position.y)
            let positionToPrint = "X: \(positionX) Y: \(positionY)"
            print(position)
            networkManager.sendMessage(message: positionToPrint)
            
        }
    }
    func decodeImage(){
        let newImageData = Data(base64Encoded: networkManager.receivedMessage)
        if let newImageData = newImageData {
            imageRead.image = UIImage(data: newImageData)!
        }
        
    }
    
}

extension NewCalculationViewController: UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typeOfService.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(typeOfService[row])
    }
    
    
}
extension NewCalculationViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typeOfService[row]
    }
}



