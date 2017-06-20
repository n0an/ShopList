//
//  ShoppingList.swift
//  ShopList
//
//  Created by Anton Novoselov on 18/06/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import Foundation
import Firebase

class ShoppingList {
    var id: String
    let name: String
    var totalPrice: Float
    var totalItems: Int
    var date: Date
    var ownerId: String
    
    init(name: String, totalPrice: Float = 0, id: String = "") {
        self.name = name
        self.totalPrice = totalPrice
        self.totalItems = 0
        self.id = id
        self.date = Date()
        self.ownerId = FUser.currentId()
        
    }
    
    init(dictionary: [String: Any]) {
        self.name = dictionary[kNAME] as! String
        self.totalPrice = dictionary[kTOTALPRICE] as! Float
        self.totalItems = dictionary[kTOTALITEMS] as! Int
        self.id = dictionary[kSHOPPINGLISTID] as! String
        self.date = dateFormatter().date(from: dictionary[kDATE] as! String)!
        self.ownerId = dictionary[kOWNERID] as! String
    }
    
    func saveItemInBackground(shoppingList: ShoppingList, completion: @escaping (_ error: Error?) -> Void) {
        let ref = firebase.child(kSHOPPINGLIST).child(FUser.currentId()).childByAutoId()
        
        shoppingList.id = ref.key
        
        ref.setValue(toDictionary(item: shoppingList)) { (error, ref) in
            completion(error)
        }
        
    }
    
    func updateItemInBackground(shoppingList: ShoppingList, completion: @escaping (_ error: Error?) -> Void) {
        let ref = firebase.child(kSHOPPINGLIST).child(FUser.currentId()).child(shoppingList.id)
        
        
        ref.setValue(toDictionary(item: shoppingList)) { (error, ref) in
            completion(error)
        }
        
    }
    
    
    func deleteItemInBackground(shoppingList: ShoppingList) {
        let ref = firebase.child(kSHOPPINGLIST).child(FUser.currentId()).child(shoppingList.id)
        
        ref.removeValue()
        
    }
    
    
    
    func toDictionary(item: ShoppingList) -> [String: Any] {
        
        let dict: [String: Any] =
            [kNAME:             item.name,
             kTOTALPRICE:       item.totalPrice,
             kTOTALITEMS:       item.totalItems,
             kSHOPPINGLISTID:   item.id,
             kDATE:             dateFormatter().string(from: item.date),
             kOWNERID:          item.ownerId]
        
        return dict
    }
    
    
}





















