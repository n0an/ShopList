//
//  AllListsViewController.swift
//  ShopList
//
//  Created by Anton Novoselov on 18/06/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit

class AllListsViewController: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - PROPERTIES
    var allLists: [ShoppingList] = []
    var nameTextField: UITextField!
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadList()
    }

    // MARK: - ACTIONS
    @IBAction func actionAddButtonTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Create Shopping List", message: "Enter the shopping list name", preferredStyle: .alert)
        
        alert.addTextField { (nameTextField) in
            nameTextField.placeholder = "Name"
            self.nameTextField = nameTextField
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let okAction = UIAlertAction(title: "Save", style: .default) { (action) in
            if self.nameTextField.text != "" {
                self.createShoppingList()
            } else {
                // KRProgressHUD.showWarning("Name is empty")
                print("Name is empty")
                
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func loadList() {
        
        firebase.child(kSHOPPINGLIST).child("1234").observe(.value) { (snapshot) in
            
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
    
    // MARK: - HELPER METHODS
    func createShoppingList() {
        let shoppingList = ShoppingList(name: nameTextField.text!)
        shoppingList.saveItemInBackground(shoppingList: shoppingList) { (error) in
            if let error = error {
//                KRProgressHUD.showError
                print(error.localizedDescription)
                return
            }
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
    
}
