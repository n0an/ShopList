//
//  AllListsViewController.swift
//  ShopList
//
//  Created by Anton Novoselov on 18/06/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit
import KRProgressHUD

class AllListsViewController: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - PROPERTIES
    var allLists: [ShoppingList] = []
    var nameTextField: UITextField!
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        KRProgressHUD.dismiss()
        
        loadList()
    }
    
    // MARK: - HELPER METHODS
    func createShoppingList() {
        let shoppingList = ShoppingList(name: nameTextField.text!)
        shoppingList.saveItemInBackground(shoppingList: shoppingList) { (error) in
            if let error = error {
                KRProgressHUD.showError(withMessage: error.localizedDescription)
                
                return
            }
        }
    }

    // MARK: - ACTIONS
    @IBAction func actionAddButtonTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: NSLocalizedString("Create Shopping List", comment: ""), message: NSLocalizedString("Enter the shopping list name", comment: ""), preferredStyle: .alert)
        
        alert.addTextField { (nameTextField) in
            nameTextField.placeholder = NSLocalizedString("Name", comment: "")
            self.nameTextField = nameTextField
            
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        
        let okAction = UIAlertAction(title: NSLocalizedString("Save", comment: ""), style: .default) { (action) in
            if self.nameTextField.text != "" {
                self.createShoppingList()
            } else {
                KRProgressHUD.showWarning(withMessage: "Name is empty")
                
                
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func loadList() {
        
        firebase.child(kSHOPPINGLIST).child(FUser.currentId()).observe(.value) { (snapshot) in
            
            self.allLists.removeAll()
            
            if snapshot.exists() {
                let snapValue = snapshot.value as! NSDictionary
                let valuesArray = snapValue.allValues as NSArray
                let sorted = valuesArray.sortedArray(using: [NSSortDescriptor(key: kDATE, ascending: false)])
                
                for list in sorted {
                    let currentList = list as! [String: Any]
                    let shoppingList = ShoppingList(dictionary: currentList)
                    self.allLists.append(shoppingList)
                    self.tableView.reloadData()
                }
                
            } else {
                print("no snap")
            }
        }
    }
    
    // MARK: - NAVIGATION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShoppingListToShoppingItem" {
            let indexPath = sender as! IndexPath
            let shoppingList = allLists[indexPath.row]
            
            let destinationVC = segue.destination as! ShoppingItemViewController
            destinationVC.shoppingList = shoppingList
            
            
        }
    }
    

}

// MARK: - UITableViewDataSource
extension AllListsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListCell", for: indexPath) as! ListCell
        
        let shoppingList = allLists[indexPath.row]
        
        cell.bindDate(item: shoppingList)
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension AllListsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.performSegue(withIdentifier: "segueShoppingListToShoppingItem", sender: indexPath)
        
    }
    
}






















