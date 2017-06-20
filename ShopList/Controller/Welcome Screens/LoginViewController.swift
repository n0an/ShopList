//
//  LoginViewController.swift
//  ShopList
//
//  Created by nag on 20/06/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit
import KRProgressHUD

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
        self.signInButton.layer.borderColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1).cgColor
        
        self.signUpButton.layer.cornerRadius = 8
        self.signUpButton.layer.borderWidth = 1
        self.signUpButton.layer.borderColor = UIColor.white.cgColor
        
        
    }
    
    func goToApp() {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
        
        vc.selectedIndex = 0
        
        self.present(vc, animated: true, completion: nil)
        
    }

    @IBAction func actionSignInButtonTapped(_ sender: Any) {
        
        guard emailTextField.text != "" && passwordTextField.text != "" else {
            return
        }
        
        KRProgressHUD.showMessage("Signing in...")
        
        FUser.loginUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error) in
            if let error = error {
                KRProgressHUD.showError(withMessage: error.localizedDescription)
                return
            }
            
            self.emailTextField.text = nil
            self.passwordTextField.text = nil
            
            self.view.endEditing(true)
            
            // go to MainTabBarController
            self.goToApp()
        }
        
    }
    // TODO: - button to dismiss keyboard
    
    @IBAction func actionForgotButtonTapped(_ sender: Any) {
        
        guard emailTextField.text != "" else {
            KRProgressHUD.showError(withMessage: "Email empty")
            return
        }
        
        resetUserPassword(email: emailTextField.text!)
        
    }
    
}







