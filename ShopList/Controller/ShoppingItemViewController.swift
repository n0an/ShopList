//
//  ShoppingItemViewController.swift
//  ShopList
//
//  Created by Anton Novoselov on 18/06/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit

class ShoppingItemViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var itemsLeftLabel: UILabel!
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    var shoppingList: ShoppingList!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func actionAddButtonTapped(_ sender: Any) {
        
        
        
    }
    

}


// MARK: - UITableViewDataSource
extension ShoppingItemViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListCell", for: indexPath) as! ListCell
        
        
        cell.bindDate(item: shoppingList)
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension ShoppingItemViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.performSegue(withIdentifier: "segueShoppingListToShoppingItem", sender: indexPath)
        
    }
    
}
