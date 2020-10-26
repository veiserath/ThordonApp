//
//  GeneralInformationViewController.swift
//  ThordonApp
//
//  Created by Kacper Młodkowski on 04/09/2020.
//  Copyright © 2020 Kacper Młodkowski. All rights reserved.
//

import UIKit

var generalInformation = [GeneralInformation]()

class GeneralInformationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var thordonDistributor: UITextField!
    @IBOutlet weak var customer: UITextField!
    @IBOutlet weak var projectReference: UITextField!
    @IBOutlet weak var calculatedBy: UITextField!
    @IBOutlet weak var checkedBy: UITextField!
    @IBOutlet weak var comments: UITextField!
    @IBOutlet weak var drawingNumber: UITextField!
    @IBOutlet weak var mrpNumber: UITextField!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setDelegates()
        addChangeListener()
        loadData()
        CoreDataManager.shared.saveContext()
        title = "General Information"
    }
    
    func setDelegates(){
        thordonDistributor.delegate = self
        customer.delegate = self
        projectReference.delegate = self
        calculatedBy.delegate = self
        checkedBy.delegate = self
        comments.delegate = self
        drawingNumber.delegate = self
        mrpNumber.delegate = self
    }
    func loadData(){
        let shared = CoreDataManager.shared
        generalInformation = shared.findAllForEntity("GeneralInformation") as! [GeneralInformation]
        
        if generalInformation.count > 0 {
            thordonDistributor.text = generalInformation[generalInformation.count - 1].thordonDistributor
            customer.text = generalInformation[generalInformation.count - 1].customer
            projectReference.text = generalInformation[generalInformation.count - 1].projectReference
            calculatedBy.text = generalInformation[generalInformation.count - 1].calculatedBy
            checkedBy.text = generalInformation[generalInformation.count - 1].checkedBy
            comments.text = generalInformation[generalInformation.count - 1].comments
            drawingNumber.text = generalInformation[generalInformation.count - 1].drawingNumber
            mrpNumber.text = generalInformation[generalInformation.count - 1].mrpNumber
        }
    }
    
    
    @IBAction func saveGeneralInfo(_ sender: Any) {
        saveData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        thordonDistributor.resignFirstResponder()
        customer.resignFirstResponder()
        projectReference.resignFirstResponder()
        calculatedBy.resignFirstResponder()
        checkedBy.resignFirstResponder()
        comments.resignFirstResponder()
        drawingNumber.resignFirstResponder()
        mrpNumber.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    func saveData() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let newItem = GeneralInformation(context: context)
        newItem.thordonDistributor = thordonDistributor.text
        newItem.customer = customer.text
        newItem.projectReference = projectReference.text
        newItem.calculatedBy = calculatedBy.text
        newItem.checkedBy = checkedBy.text
        newItem.comments = comments.text
        newItem.drawingNumber = drawingNumber.text
        newItem.mrpNumber = mrpNumber.text
        CoreDataManager.shared.saveContext()
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        saveData()
    }
    
    func addChangeListener(){
        thordonDistributor.addTarget(self, action: #selector(GeneralInformationViewController.textFieldDidChange(_:)), for: .editingChanged)
        customer.addTarget(self, action: #selector(GeneralInformationViewController.textFieldDidChange(_:)), for: .editingChanged)
        projectReference.addTarget(self, action: #selector(GeneralInformationViewController.textFieldDidChange(_:)), for: .editingChanged)
        calculatedBy.addTarget(self, action: #selector(GeneralInformationViewController.textFieldDidChange(_:)), for: .editingChanged)
        checkedBy.addTarget(self, action: #selector(GeneralInformationViewController.textFieldDidChange(_:)), for: .editingChanged)
        comments.addTarget(self, action: #selector(GeneralInformationViewController.textFieldDidChange(_:)), for: .editingChanged)
        drawingNumber.addTarget(self, action: #selector(GeneralInformationViewController.textFieldDidChange(_:)), for: .editingChanged)
        mrpNumber.addTarget(self, action: #selector(GeneralInformationViewController.textFieldDidChange(_:)), for: .editingChanged)
    }
    
}
