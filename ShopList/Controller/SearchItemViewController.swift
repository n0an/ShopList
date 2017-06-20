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

protocol SearchItemViewControllerDelegate: class {
    func didChooseItem(groceryItem: GroceryItem)
}

class SearchItemViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    var groceryItems: [GroceryItem] = []
    var filteredItems: [GroceryItem] = []
    
    var defaultOptions = SwipeTableOptions()
    var isSwipeRightEnable = true
    
    var clickToEdit = true
    
    let searchController = UISearchController(searchResultsController: nil)
    
    weak var delegate: SearchItemViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelButton.isHidden = clickToEdit
        addButton.isHidden = !clickToEdit
        
        // Search bar configuration
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        tableView.tableHeaderView = searchController.searchBar
        
        loadGroceryItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
//        self.tableView.setContentOffset(CGPoint(x: 0.0, y: 44.0), animated: true)
    }
    
    // MARK: - HELPER METHODS
    func loadGroceryItems() {
        firebase.child(kGROCERYITEM).child(FUser.currentId()).observe(.value) { (snapshot) in
            
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
    
    @IBAction func actionCancelButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
}

// MARK: - UITableViewDataSource
extension SearchItemViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredItems.count
        } else {
            return self.groceryItems.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingItemCell", for: indexPath) as! ShoppingItemCell
        
        cell.delegate = self
        cell.selectedBackgroundView = createSelectedBackgroundView()
        
        var item: GroceryItem
        
        if searchController.isActive && searchController.searchBar.text != "" {
            item = self.filteredItems[indexPath.row]
        } else {
            item = self.groceryItems[indexPath.row]
        }
        
        cell.bindGroceryItem(item: item)
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension SearchItemViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        var item: GroceryItem
        
        if searchController.isActive && searchController.searchBar.text != "" {
            item = self.filteredItems[indexPath.row]
        } else {
            item = self.groceryItems[indexPath.row]
        }
        
        if !clickToEdit {
            // add to current shopping list
            
            self.delegate?.didChooseItem(groceryItem: item)
            
            self.dismiss(animated: true, completion: nil)
            
        } else {
            
            let addItemVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddItemViewController") as! AddItemViewController
            
            addItemVC.groceryItem = item
            
            self.present(addItemVC, animated: true, completion: nil)
        }
        
        
        
    }
}

// MARK: - UISearchResultsUpdating
extension SearchItemViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
        
        tableView.reloadData()
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredItems = groceryItems.filter({ (item) -> Bool in
            return item.name.lowercased().contains(searchText.lowercased())
        })
    }
    
}

// MARK: - SwipeTableViewCellDelegate
extension SearchItemViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        if orientation == .left {
            guard isSwipeRightEnable else { return nil }
        }
        
        let delete = SwipeAction(style: .destructive, title: nil, handler: { (action, indexPath) in
            
            var item: GroceryItem
            
            if self.searchController.isActive && self.searchController.searchBar.text != "" {
                item = self.filteredItems[indexPath.row]
            } else {
                item = self.groceryItems[indexPath.row]
            }
            
            self.groceryItems.remove(at: indexPath.row)
            item.deleteItemInBackground(groceryItem: item)
            
            self.tableView.beginUpdates()
            action.fulfill(with: .delete)
            self.tableView.endUpdates()
            
        })
        
        configure(action: delete, with: .trash)
        return [delete]
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





