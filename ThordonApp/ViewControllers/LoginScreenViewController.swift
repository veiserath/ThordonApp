//
//  LoginScreenViewController.swift
//  ThordonApp
//
//  Created by Kacper Młodkowski on 06/11/2020.
//  Copyright © 2020 Kacper Młodkowski. All rights reserved.
//

import UIKit

class LoginScreenViewController: UIViewController {
    
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func loginButtonIsClicked(_ sender: Any) {
        if loginTextField.text != nil && passwordTextField.text != nil{
            LoginCredentials.init(login: loginTextField.text!, password: passwordTextField.text!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    @IBAction func loginTapped(_ sender: Any) {
        
        // ...
        // after login is done, maybe put this in the login web service completion block

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
        
        // This is to get the SceneDelegate object from your view controller
        // then call the change root view controller function to change to main tab bar
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
        
        
    }
    
   
    
    
    
    
    
    
    
    
}
