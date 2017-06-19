//
//  SearchItemViewController.swift
//  ShopList
//
//  Created by Anton Novoselov on 19/06/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit
import KRProgressHUD
import SwipeCellKit

class SearchItemViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    var groceryItems: [GroceryItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadGroceryItems()
    }
    
    // MARK: - HELPER METHODS
    func loadGroceryItems() {
        firebase.child(kGROCERYITEM).child("1234").observe(.value) { (snapshot) in
            
            self.groceryItems.removeAll()
            
            if snapshot.exists() {
                let snapValue = snapshot.value as! NSDictionary
                let valuesArray = snapValue.allValues as NSArray
                
                for item in valuesArray {
                    let currentItem = item as! [String: Any]
                    let groceryItem = GroceryItem(dictionary: currentItem)
                    self.groceryItems.append(groceryItem)
                    self.tableView.reloadData()
                }
                
            } else {
                print("no snap")
            }
        }
    }
    

    @IBAction func actionAddButtonTapped(_ sender: Any) {
        let addItemVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddItemViewController") as! AddItemViewController
        
        addItemVC.addingToList = true
        
        self.present(addItemVC, animated: true, completion: nil)
        
    }
    
}

// MARK: - UITableViewDataSource
extension SearchItemViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groceryItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingItemCell", for: indexPath) as! ShoppingItemCell
        
//        cell.delegate = self
        cell.selectedBackgroundView = createSelectedBackgroundView()
        
        let item = self.groceryItems[indexPath.row]
        
        cell.bindGroceryItem(item: item)
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension SearchItemViewController: UITableViewDelegate {
    
}


// MARK: - SwipeTableViewCellDelegate





