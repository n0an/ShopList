//
//  ShoppingItemViewController.swift
//  ShopList
//
//  Created by Anton Novoselov on 18/06/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit
import KRProgressHUD
import SwipeCellKit

class ShoppingItemViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var itemsLeftLabel: UILabel!
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    var shoppingList: ShoppingList!
    
    var shoppingItems: [ShoppingItem] = []
    var boughtItems: [ShoppingItem] = []
    
    var defaultOptions = SwipeTableOptions()
    var isSwipeRightEnable = true
    
    var totalPrice: Float!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        totalPrice = shoppingList.totalPrice
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "BackArrow"), style: .done, target: self, action: #selector(self.goback))
        
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
                    
                    self.calculateTotal()
                    self.updateUI()
                }
                
            } else {
                print("no snap")
            }
        }
    }
    
    func updateUI() {
        
        var currency: String = "$"
        
        if let curr = userDefaults.value(forKey: kCURRENCY) as? String {
            currency = curr
        }
        
        self.itemsLeftLabel.text = NSLocalizedString("Items Left: ", comment: "") + "\(self.shoppingItems.count)"
        let formattedTotalPrice = String(format: "%.2f", self.totalPrice)
        self.totalPriceLabel.text = NSLocalizedString("Total Price: ", comment: "") + "\(currency) \(formattedTotalPrice)"
        
        
        self.tableView.reloadData()
    }
    
    func calculateTotal() {
        
        self.totalPrice = 0
        
        for item in boughtItems {
            self.totalPrice = self.totalPrice + item.price
        }
        
        for item in shoppingItems {
            self.totalPrice = self.totalPrice +  item.price
        }
        
        let formattedTotalPrice = String(format: "%.2f", self.totalPrice)
        self.totalPriceLabel.text = "Total Price: \(formattedTotalPrice)"
        
        shoppingList.totalPrice = self.totalPrice
        shoppingList.totalItems = self.boughtItems.count + self.shoppingItems.count
        
        shoppingList.updateItemInBackground(shoppingList: shoppingList) { (error) in
            if let error = error {
                KRProgressHUD.showError(withMessage: error.localizedDescription)
                return
            }
        }
    }
    
    @objc func goback() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - ACTIONS
    @IBAction func actionAddButtonTapped(_ sender: Any) {
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let newItemAction = UIAlertAction(title: NSLocalizedString("New Item", comment: ""), style: .default) { (action) in
            let addItemVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddItemViewController") as! AddItemViewController
            
            addItemVC.shoppingList = self.shoppingList
            addItemVC.addingToList = false
            
            self.present(addItemVC, animated: true, completion: nil)
        }
        
        let searchItemAction = UIAlertAction(title: NSLocalizedString("Search Item", comment: ""), style: .default) { (action) in
            
            let searchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchItemViewController") as! SearchItemViewController
            
            searchVC.delegate = self
            searchVC.clickToEdit = false
            
            self.present(searchVC, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        
        optionMenu.addAction(newItemAction)
        optionMenu.addAction(searchItemAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
}

// MARK: - +++ SearchItemViewControllerDelegate +++
extension ShoppingItemViewController: SearchItemViewControllerDelegate {
    func didChooseItem(groceryItem: GroceryItem) {
        
        let shoppingItem = ShoppingItem(groceryItem: groceryItem)
        
        shoppingItem.shoppingListId = shoppingList.id
        
        shoppingItem.saveItemInBackground(shoppingItem: shoppingItem) { (error) in
            if let error = error {
                KRProgressHUD.showError(withMessage: error.localizedDescription)
            }
        }
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
        
        cell.delegate = self
        cell.selectedBackgroundView = createSelectedBackgroundView()
        
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
            title = NSLocalizedString("SHOPPING LIST", comment: "")
        } else {
            title = NSLocalizedString("BOUGHT LIST", comment: "")
        }
        
        return titleViewForTable(title: title)
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        var shoppingItem: ShoppingItem
        
        if indexPath.section == 0 {
            shoppingItem = shoppingItems[indexPath.row]
        } else {
            shoppingItem = boughtItems[indexPath.row]
        }
        
        let addItemVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddItemViewController") as! AddItemViewController
        
        addItemVC.shoppingList = shoppingList
        addItemVC.shoppingItem = shoppingItem
        
        self.present(addItemVC, animated: true, completion: nil)
        
    }
    
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

// MARK: - SwipeTableViewCellDelegate
extension ShoppingItemViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        var shoppingItem: ShoppingItem
        
        if indexPath.section == 0 {
            shoppingItem = shoppingItems[indexPath.row]
        } else {
            shoppingItem = boughtItems[indexPath.row]
        }
        
        if orientation == .left {
            guard isSwipeRightEnable else { return nil }
            
            let buyItem = SwipeAction(style: .default, title: nil, handler: { (action, indexPath) in
                
                shoppingItem.isBought = !shoppingItem.isBought
                
                shoppingItem.updateItemInBackground(shoppingItem: shoppingItem, completion: { (error) in
                    if let error = error {
                        KRProgressHUD.showError(withMessage: error.localizedDescription)
                        return
                    }
                })
                
                if indexPath.section == 0 {
                    self.shoppingItems.remove(at: indexPath.row)
                    self.boughtItems.append(shoppingItem)
                } else {
                    self.boughtItems.remove(at: indexPath.row)
                    self.shoppingItems.append(shoppingItem)
                }
                tableView.reloadData()
            })
            
            buyItem.accessibilityLabel = shoppingItem.isBought ? NSLocalizedString("Buy", comment: "") : NSLocalizedString("Return", comment: "")
            let descriptor: ActionDescriptor = shoppingItem.isBought ? .returnPurchase : .buy
            
            configure(action: buyItem, with: descriptor)
            
            return [buyItem]
        } else {
            
            let delete = SwipeAction(style: .destructive, title: nil, handler: { (action, indexPath) in
                
                if indexPath.section == 0 {
                    self.shoppingItems.remove(at: indexPath.row)
                } else {
                    self.boughtItems.remove(at: indexPath.row)
                }
                
                shoppingItem.deleteItemInBackground(shoppingItem: shoppingItem)
                
                self.tableView.beginUpdates()
                action.fulfill(with: .delete)
                self.tableView.endUpdates()
                
            })
            
            configure(action: delete, with: .trash)
            return [delete]
        }
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        
        var options = SwipeTableOptions()
        options.expansionStyle = orientation == .left ? .selection : .destructive
        
        options.transitionStyle = defaultOptions.transitionStyle
        options.buttonSpacing = 11
        
        return options
        
    }
    
    
    func configure(action: SwipeAction, with descriptor: ActionDescriptor) {
        action.title = descriptor.title()
        action.image = descriptor.image()
        action.backgroundColor = descriptor.color
    }
    
}












