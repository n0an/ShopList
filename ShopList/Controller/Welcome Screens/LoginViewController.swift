//
//  LoginViewController.swift
//  ShopList
//
//  Created by nag on 20/06/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.signInButton.layer.cornerRadius = 8
        self.signInButton.layer.borderWidth = 1
        self.signInButton.layer.borderColor = UIColor.blue.cgColor
        
        self.signUpButton.layer.cornerRadius = 8
        self.signUpButton.layer.borderWidth = 1
        self.signUpButton.layer.borderColor = UIColor.white.cgColor
        
        
    }

    @IBAction func actionSignInButtonTapped(_ sender: Any) {
        
    }
    
    
    @IBAction func actionForgotButtonTapped(_ sender: Any) {
        
        
    }
    
}
