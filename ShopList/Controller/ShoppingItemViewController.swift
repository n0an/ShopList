//
//  ShoppingItemViewController.swift
//  ShopList
//
//  Created by Anton Novoselov on 18/06/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit
import KRProgressHUD

class ShoppingItemViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var itemsLeftLabel: UILabel!
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    var shoppingList: ShoppingList!
    
    var shoppingItems: [ShoppingItem] = []
    var boughtItems: [ShoppingItem] = []
    
//    var defaultOption = SwipeTableOptions()
    var isSwipeRightEnable = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadShoppingItems()
    }
    
    
    // MARK: - HELPER METHODS
    func loadShoppingItems() {
        firebase.child(kSHOPPINGITEM).child(shoppingList.id).queryOrdered(byChild: kSHOPPINGLISTID).queryEqual(toValue: shoppingList.id).observe(.value) { (snapshot) in
            
            self.shoppingItems.removeAll()
            self.boughtItems.removeAll()
            
            if snapshot.exists() {
                let snapValue = snapshot.value as! [String: Any]
                let valuesArray = snapValue.values
                
                for item in valuesArray {
                    let currentItem = item as! [String: Any]
                    let shoppingItem = ShoppingItem(dictionary: currentItem)
                    
                    if shoppingItem.isBought {
                        self.boughtItems.append(shoppingItem)
                    } else {
                        self.shoppingItems.append(shoppingItem)
                    }
                    
                    self.tableView.reloadData()
                }
                
            } else {
                print("no snap")
            }
            
        }
    }
    
    
    // MARK: - ACTIONS
    @IBAction func actionAddButtonTapped(_ sender: Any) {
        
        let addItemVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddItemViewController") as! AddItemViewController
        
        addItemVC.shoppingList = shoppingList
        
        self.present(addItemVC, animated: true, completion: nil)
        
    }
    
}


// MARK: - UITableViewDataSource
extension ShoppingItemViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return shoppingItems.count
        } else {
            return boughtItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingItemCell", for: indexPath) as! ShoppingItemCell
        
        var shoppingItem: ShoppingItem
        
        if indexPath.section == 0 {
            shoppingItem = shoppingItems[indexPath.row]
        } else {
            shoppingItem = boughtItems[indexPath.row]
        }
        
        cell.bindDate(item: shoppingItem)
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension ShoppingItemViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var title: String
        
        if section == 0 {
            title = "SHOPPING LIST"
        } else {
            title = "BOUGHT LIST"
        }
        
        return titleViewForTable(title: title)
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
        
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        self.performSegue(withIdentifier: "segueShoppingListToShoppingItem", sender: indexPath)
//
//    }
    
    func titleViewForTable(title: String) -> UIView {
        
        let view = UIView()
        view.backgroundColor = UIColor.darkGray
        
        let titleLabel = UILabel(frame: CGRect(x: 10, y: 5, width: 200, height: 20))
        titleLabel.text = title
        titleLabel.textColor = UIColor.white
        
        view.addSubview(titleLabel)
        
        return view
    }
    
    
    
}












