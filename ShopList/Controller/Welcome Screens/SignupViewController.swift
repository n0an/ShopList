//
//  SignupViewController.swift
//  ShopList
//
//  Created by nag on 20/06/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit
import KRProgressHUD

class SignupViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.signInButton.layer.cornerRadius = 8
        self.signInButton.layer.borderWidth = 1
        self.signInButton.layer.borderColor = UIColor.white.cgColor
        
        self.signUpButton.layer.cornerRadius = 8
        self.signUpButton.layer.borderWidth = 1
        self.signUpButton.layer.borderColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1).cgColor
    }
    
    func goToApp() {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
        
        vc.selectedIndex = 0
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    // TODO: - dismiss keyboard button
    
    @IBAction func actionSignUpButtonTapped(_ sender: Any) {
        
        guard emailTextField.text != "" && passwordTextField.text != ""  && firstNameTextField.text != "" && lastNameTextField.text != "" else {
            KRProgressHUD.showError(withMessage: "All fields are required")
            return
        }
        
        KRProgressHUD.showMessage("Signing Up...")
        
        FUser.registerUserWith(email: emailTextField.text!, password: passwordTextField.text!, firstName: firstNameTextField.text!, lastName: lastNameTextField.text!) { (error) in
            if let error = error {
                KRProgressHUD.showError(withMessage: error.localizedDescription)
                return
            }
            
            self.goToApp()
            
        }
        
    }

    @IBAction func actioinSignInButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    

}