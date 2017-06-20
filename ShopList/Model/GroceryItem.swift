//
//  GroceryItem.swift
//  ShopList
//
//  Created by Anton Novoselov on 19/06/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import Foundation

class GroceryItem {
    
    var name: String
    var info: String
    var price: Float
    let ownerId: String
    var image: String
    var groceryItemId: String
    
    init(name: String, info: String = "", price: Float, image: String = "") {
        self.name = name
        self.info = info
        self.price = price
        self.ownerId = FUser.currentId()
        self.image = ""
        self.groceryItemId = ""
    }
    
    init(dictionary: [String: Any]) {
        self.name = dictionary[kNAME] as! String
        self.info = dictionary[kINFO] as! String
        self.price = dictionary[kPRICE] as! Float
        self.ownerId = dictionary[kOWNERID] as! String
        self.image = dictionary[kIMAGE] as! String
        self.groceryItemId = dictionary[kGROCERYITEMID] as! String
    }
    
    init(shoppingItem: ShoppingItem) {
        self.name = shoppingItem.name
        self.info = shoppingItem.info
        self.price = shoppingItem.price
        self.ownerId = FUser.currentId()
        self.image = shoppingItem.image
        self.groceryItemId = ""
    }
    
    func saveItemInBackground(groceryItem: GroceryItem, completion: @escaping (_ error: Error?) -> Void) {
        let ref = firebase.child(kGROCERYITEM).child(FUser.currentId()).childByAutoId()
        
        groceryItem.groceryItemId = ref.key
        
        ref.setValue(toDictionary(item: groceryItem)) { (error, ref) in
            completion(error)
        }
        
    }
    
    func updateItemInBackground(groceryItem: GroceryItem, completion: @escaping (_ error: Error?) -> Void) {
        let ref = firebase.child(kGROCERYITEM).child(FUser.currentId()).child(groceryItem.groceryItemId)
        
        
        ref.setValue(toDictionary(item: groceryItem)) { (error, ref) in
            completion(error)
        }
        
    }
    
    
    func deleteItemInBackground(groceryItem: GroceryItem) {
        let ref = firebase.child(kGROCERYITEM).child(FUser.currentId()).child(groceryItem.groceryItemId)
        
        ref.removeValue()
        
    }
    
    
    func toDictionary(item: GroceryItem) -> [String: Any] {
        
        let dict: [String: Any] =
            [kNAME:             item.name,
             kINFO:             item.info,
             kPRICE:            item.price,
             kOWNERID:          item.ownerId,
             kIMAGE:            item.image,
             kGROCERYITEMID:    item.groceryItemId
        ]
        
        return dict
    }
    
    
}














