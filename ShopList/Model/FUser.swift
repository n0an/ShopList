//
//  FUser.swift
//  ShopList
//
//  Created by nag on 20/06/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase
import KRProgressHUD

class FUser {
    
    let objectId: String
    let createdAt: Date
    var email: String
    var firstName: String
    var lastName: String
    var fullname: String
    
    init(objectId: String, createdAt: Date, email: String, firstName: String, lastName: String) {
        self.objectId = objectId
        self.createdAt = createdAt
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.fullname = firstName + " " + lastName
        
    }
    
    init(dictionary: [String: Any]) {
        self.objectId = dictionary[kOBJECTID] as! String
        self.createdAt = dateFormatter().date(from: dictionary[kCREATEDAT] as! String)!
        self.email = dictionary[kEMAIL] as! String
        self.firstName = dictionary[kFIRSTNAME] as! String
        self.lastName = dictionary[kLASTNAME] as! String
        self.fullname = dictionary[kFULLNAME] as! String
        
    }
    
    // MARK: Returning current user methods
    
    class func currentId() -> String {
        return (Auth.auth().currentUser?.uid)!
        
    }
    
    class func currentUser() -> FUser? {
        if Auth.auth().currentUser != nil {
            if let dictionary = userDefaults.object(forKey: kCURRENTUSER) {
                return FUser(dictionary: dictionary as! [String : Any])
            }
        }
        return nil
    }
    
    // MARK: - Login/SignUp methods
    
    class func loginUserWith(email: String, password: String, completion: @escaping (_ error: Error?) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (firUser, error) in
            
            if let error = error {
                completion(error)
                return
            }
            
            // Fetch user from Firebase
            fetchUser(userId: (firUser?.uid)!, completion: { (success) in
                if success {
                    print("user logged successfully")
                }
            })
            
            
            completion(nil)
        }
        
    }
    
    class func registerUserWith(email: String, password: String, firstName: String, lastName: String, completion: @escaping (_ error: Error?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (firUser, error) in
            if let error = error {
                completion(error)
                return
            }
            
            let fUser = FUser(objectId: firUser!.uid, createdAt: Date(), email: firUser!.email!, firstName: firstName, lastName: lastName)
            
            // Save to UserDefaults
            saveUserLocally(fUser: fUser)
            
            // Save to Firebase
            saveUserInBackground(fUser: fUser)
            
            completion(nil)
            
        }
    }
    
    class func logoutUser(completion: @escaping (_ success: Bool) -> Void) {
        
        userDefaults.removeObject(forKey: kCURRENTUSER)
        userDefaults.synchronize()
        
        do {
            try Auth.auth().signOut()
            completion(true)
        } catch {
            completion(false)
            print(error.localizedDescription)
            
        }
    }
}


// MARK: Save user methods

func saveUserLocally(fUser: FUser) {
    UserDefaults.standard.set(toDictionary(user: fUser), forKey: kCURRENTUSER)
    UserDefaults.standard.synchronize()
}


func saveUserInBackground(fUser: FUser) {
    let ref = firebase.child(kUSER).child(fUser.objectId)
    ref.setValue(toDictionary(user: fUser))
}

func toDictionary(user: FUser) -> [String: Any] {
    
    let dict: [String: Any] =
        [kOBJECTID:         user.objectId,
         kCREATEDAT:        dateFormatter().string(from: user.createdAt),
         kEMAIL:            user.email,
         kFIRSTNAME:        user.firstName,
         kLASTNAME:         user.lastName,
         kFULLNAME:         user.fullname
    ]
    
    return dict
}

func fetchUser(userId: String, completion: @escaping (_ success: Bool) -> Void) {
    
    firebase.child(kUSER).queryOrdered(byChild: kOBJECTID).queryEqual(toValue: userId).observe(.value) { (snapshot) in
        
        
        if snapshot.exists() {
            
            
            let snapValue = snapshot.value as! NSDictionary
            let valuesArray = snapValue.allValues as NSArray
            
            let user = valuesArray.firstObject! as! [String: Any]
            
            UserDefaults.standard.set(user, forKey: kCURRENTUSER)
            UserDefaults.standard.synchronize()
            
            completion(true)
            
        } else {
            print("no snap")
            completion(false)
        }
        
        
    }
    
    
}

func resetUserPassword(email: String) {
    Auth.auth().sendPasswordReset(withEmail: email) { (error) in
        if let error = error {
            KRProgressHUD.showError(withMessage: error.localizedDescription)
        } else {
            KRProgressHUD.showSuccess(withMessage: "Password email sent")
        }
    }
}

func cleanupFirebaseObservers() {
    firebase.child(kUSER).removeAllObservers()
    firebase.child(kSHOPPINGLIST).removeAllObservers()
    firebase.child(kSHOPPINGITEM).removeAllObservers()
    firebase.child(kGROCERYITEM).removeAllObservers()
}







