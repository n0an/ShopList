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
    var groceryItem: GroceryItem!
    var itemImage: UIImage!
    
    var addingToList: Bool?
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        let image = UIImage(named: "ShoppingCartEmpty")?.scaleImageToSize(newSize: itemImageView.frame.size)
        itemImageView.image = image?.circleMasked
        
        if shoppingItem != nil || groceryItem != nil {
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
            
            showListNotification(shoppingItem: shoppingItem)
        }
    }
    
    func showListNotification(shoppingItem: ShoppingItem) {
        let alert = UIAlertController(title: "Shopping Items", message: "Do you want to add this item to your items", preferredStyle: .alert)
        
        let noAction = UIAlertAction(title: "No", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            // save to grocery list
            
            let groceryItem = GroceryItem(shoppingItem: shoppingItem)
            
            groceryItem.saveItemInBackground(groceryItem: groceryItem, completion: { (error) in
                if let error = error {
                    KRProgressHUD.showError(withMessage: error.localizedDescription)
                    return
                }
            })
            
            self.dismiss(animated: true, completion: nil)
            
        }
        
        alert.addAction(noAction)
        alert.addAction(yesAction)
        
        self.present(alert, animated: true, completion: nil)
        
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
        } else if groceryItem != nil {
            
            groceryItem.name = nameTextField.text!
            groceryItem.info = extraInfoTextField.text!
            groceryItem.price = Float(priceTextField.text!)!
            
            groceryItem.image = imageString
            
            groceryItem.updateItemInBackground(groceryItem: groceryItem) { (error) in
                if let error = error {
                    
                    KRProgressHUD.showError(withMessage: error.localizedDescription)
                    return
                }
            }
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateUI() {
        
        if shoppingItem != nil {
            
            self.nameTextField.text = self.shoppingItem.name
            self.extraInfoTextField.text = self.shoppingItem.info
            self.quantityTextField.text = self.shoppingItem.quantity
            self.priceTextField.text = String(shoppingItem.price)
            
            if shoppingItem.image != "" {
                
                if let image = imageFromData(pictureData: shoppingItem.image) {
                    let scaledImage = image.scaleImageToSize(newSize: itemImageView.frame.size)
                    itemImageView.image = scaledImage.circleMasked
                    itemImage = scaledImage
                }
            }
        } else if groceryItem != nil {
            self.nameTextField.text = self.groceryItem.name
            self.extraInfoTextField.text = self.groceryItem.info
            self.quantityTextField.text = ""
            self.priceTextField.text = String(groceryItem.price)
            
            if groceryItem.image != "" {
                
                if let image = imageFromData(pictureData: groceryItem.image) {
                    let scaledImage = image.scaleImageToSize(newSize: itemImageView.frame.size)
                    itemImageView.image = scaledImage.circleMasked
                    itemImage = scaledImage
                }
            }
        }
        
    }
    
    // MARK: - ACTIONS
    @IBAction func actionSaveButtonTapped(_ sender: Any) {
        if nameTextField.text != "" &&
            priceTextField.text != "" {
            
            if shoppingItem != nil || groceryItem != nil {
                
                self.updateItem()
                
            } else {
                saveItem()
            }
            
        } else {
            KRProgressHUD.showWarning(withMessage: "Empty fields")
        }
        
//        self.dismiss(animated: true, completion: nil)
        
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



















