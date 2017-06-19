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
    var shoppingItem: ShoppingItem!
    var itemImage: UIImage!
    
    var addingToList: Bool?
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        let image = UIImage(named: "ShoppingCartEmpty")?.scaleImageToSize(newSize: itemImageView.frame.size)
        itemImageView.image = image?.circleMasked
        
        if shoppingItem != nil {
            updateUI()
        }
    }
    
    // MARK: - HELPER METHODS
    func saveItem() {
        
        var tmpItem: ShoppingItem
        var imageString: String!
        
        if itemImage != nil {
            if let imageData = UIImageJPEGRepresentation(itemImage, 0.5) {
                
                imageString = imageData.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
            }
        } else {
            imageString = ""
        }
        
        if addingToList! {
            // add to grocery list only
            
            tmpItem = ShoppingItem(name: nameTextField.text!, info: extraInfoTextField.text!, price: Float(priceTextField.text!)!, shoppingListId: "")
            
            let groceryItem = GroceryItem(shoppingItem: tmpItem)
            groceryItem.image = imageString
            
            groceryItem.saveItemInBackground(groceryItem: groceryItem, completion: { (error) in
                if let error = error {
                    KRProgressHUD.showError(withMessage: error.localizedDescription)
                }
            })
            self.dismiss(animated: true, completion: nil)
            
        } else {
            // add to current shopping list
            let shoppingItem = ShoppingItem(name: nameTextField.text!, info: extraInfoTextField.text!, quantity: quantityTextField.text!, price: Float(priceTextField.text!)!, shoppingListId: shoppingList.id)
            
            shoppingItem.image = imageString
            
            shoppingItem.saveItemInBackground(shoppingItem: shoppingItem) { (error) in
                if let error = error {
                    KRProgressHUD.showError(withMessage: error.localizedDescription)
                    return
                }
            }
            
        }
        
        
    }
    
    func updateItem() {
        
        var imageString: String!
        
        if itemImage != nil {
            if let imageData = UIImageJPEGRepresentation(itemImage, 0.5) {
                
                imageString = imageData.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
            }
        } else {
            imageString = ""
        }
        
        if shoppingItem != nil {
            
            shoppingItem.name = nameTextField.text!
            shoppingItem.info = extraInfoTextField.text!
            shoppingItem.price = Float(priceTextField.text!)!
            shoppingItem.quantity = quantityTextField.text!
            
            shoppingItem.image = imageString
            
            shoppingItem.updateItemInBackground(shoppingItem: shoppingItem) { (error) in
                if let error = error {
                    
                    KRProgressHUD.showError(withMessage: error.localizedDescription)
                    return
                }
            }
        }
        
    }
    
    func updateUI() {
        
        guard shoppingItem != nil else {
            return
        }
        
        self.nameTextField.text = self.shoppingItem.name
        self.extraInfoTextField.text = self.shoppingItem.info
        self.quantityTextField.text = self.shoppingItem.quantity
        self.priceTextField.text = String(shoppingItem.price)
        
        if shoppingItem.image != "" {
            
            if let image = imageFromData(pictureData: shoppingItem.image) {
                let scaledImage = image.scaleImageToSize(newSize: itemImageView.frame.size)
                itemImageView.image = scaledImage.circleMasked
            }
        }
    }
    
    
    
    // MARK: - ACTIONS
    @IBAction func actionSaveButtonTapped(_ sender: Any) {
        if nameTextField.text != "" &&
            priceTextField.text != "" {
            
            if shoppingItem != nil {
                
                self.updateItem()
                
            } else {
                saveItem()
            }
            
        } else {
            KRProgressHUD.showWarning(withMessage: "Empty fields")
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func actionCancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImageButtonTapped(_ sender: Any) {
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default) { (action) in
            // show camera
            let camera = Camera(delegate_: self)
            camera.PresentPhotoCamera(target: self, canEdit: true)
        }
        
        let sharePhotoAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            // from library
            let camera = Camera(delegate_: self)
            camera.PresentPhotoLibrary(target: self, canEdit: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        optionMenu.addAction(takePhotoAction)
        optionMenu.addAction(sharePhotoAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    

}

// MARK: - UIImagePickerControllerDelegate
extension AddItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.itemImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        let newImage = itemImage.scaleImageToSize(newSize: itemImageView.frame.size)
        
        self.itemImageView.image = newImage.circleMasked
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    
}



















