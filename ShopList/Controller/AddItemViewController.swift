//
//  AddItemViewController.swift
//  ShopList
//
//  Created by Anton Novoselov on 18/06/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit
import KRProgressHUD

class AddItemViewController: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var extraInfoTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var itemImageView: UIImageView!
    
    var shoppingList: ShoppingList!
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    // MARK: - HELPER METHODS
    func saveItem() {
        
        let shoppingItem = ShoppingItem(name: nameTextField.text!, info: extraInfoTextField.text!, quantity: quantityTextField.text!, price: Float(priceTextField.text!)!, shoppingListId: shoppingList.id)
        
        shoppingItem.saveItemInBackground(shoppingItem: shoppingItem) { (error) in
            if let error = error {
                KRProgressHUD.showError(withMessage: error.localizedDescription)
                return
            }
        }
        
    }
    
    // MARK: - ACTIONS
    @IBAction func actionSaveButtonTapped(_ sender: Any) {
        if nameTextField.text != "" &&
            priceTextField.text != "" {
            
            saveItem()
            
        } else {
            KRProgressHUD.showWarning(withMessage: "Empty fields")
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func actionCancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
