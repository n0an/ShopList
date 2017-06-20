//
//  ShoppingItem.swift
//  ShopList
//
//  Created by Anton Novoselov on 18/06/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import Foundation

class ShoppingItem {
    
    var name: String
    var info: String
    var quantity: String
    var price: Float
    var shoppingItemId: String
    var shoppingListId: String
    var isBought: Bool
    var image: String
    
    init(name: String, info: String = "", quantity: String = "1", price: Float, shoppingListId: String) {
        self.name = name
        self.info = info
        self.quantity = quantity
        self.price = price
        self.shoppingItemId = ""
        self.shoppingListId = shoppingListId
        self.isBought = false
        self.image = ""
    }
    
    init(dictionary: [String: Any]) {
        self.name = dictionary[kNAME] as! String
        self.info = dictionary[kINFO] as! String
        self.quantity = dictionary[kQUANTITY] as! String
        self.price = dictionary[kPRICE] as! Float
        self.shoppingItemId = dictionary[kSHOPPINGITEMID] as! String
        self.shoppingListId = dictionary[kSHOPPINGLISTID] as! String
        self.isBought = dictionary[kISBOUGHT] as! Bool
        self.image = dictionary[kIMAGE] as! String
    }
    
    init(groceryItem: GroceryItem) {
        self.name = groceryItem.name
        self.info = groceryItem.info
        self.price = groceryItem.price
        self.image = groceryItem.image
        self.quantity = "1"
        self.shoppingItemId = ""
        self.shoppingListId = ""
        self.isBought = false
        
    }
    
    func saveItemInBackground(shoppingItem: ShoppingItem, completion: @escaping (_ error: Error?) -> Void) {
        let ref = firebase.child(kSHOPPINGITEM).child(shoppingItem.shoppingListId).childByAutoId()
        
        shoppingItem.shoppingItemId = ref.key
        
        ref.setValue(toDictionary(item: shoppingItem)) { (error, ref) in
            completion(error)
        }
        
    }
    
    func deleteItemInBackground(shoppingItem: ShoppingItem) {
        let ref = firebase.child(kSHOPPINGITEM).child(shoppingItem.shoppingListId).child(shoppingItem.shoppingItemId)
        
        ref.removeValue()
        
    }
    
    func updateItemInBackground(shoppingItem: ShoppingItem, completion: @escaping (_ error: Error?) -> Void) {
        let ref = firebase.child(kSHOPPINGITEM).child(shoppingItem.shoppingListId).child(shoppingItem.shoppingItemId)
        
        
        ref.setValue(toDictionary(item: shoppingItem)) { (error, ref) in
            completion(error)
        }
        
    }
    
    
    func toDictionary(item: ShoppingItem) -> [String: Any] {
        
        let dict: [String: Any] =
            [kNAME:             item.name,
             kINFO:             item.info,
             kQUANTITY:         item.quantity,
             kPRICE:            item.price,
             kSHOPPINGITEMID:   item.shoppingItemId,
             kSHOPPINGLISTID:   item.shoppingListId,
             kISBOUGHT:         item.isBought,
             kIMAGE:            item.image
             ]
        
        return dict
    }
    
}
