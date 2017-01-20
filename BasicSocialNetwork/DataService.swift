//
//  DataService.swift
//  BasicSocialNetwork
//
//  Created by admin on 10/24/16.
//  Copyright © 2016 gdw. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

let DB_BASE = FIRDatabase.database().reference()
let STORAGE_BASE = FIRStorage.storage().reference()

class DataService {
    
    static let ds = DataService()
    //DB references
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_BOOKS = DB_BASE.child("books")
    private var _REF_USERS = DB_BASE.child("users")
    //Storage references
    private var _REF_POST_IMAGES = STORAGE_BASE.child("post-pics")
    
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    var REF_BOOKS: FIRDatabaseReference {
        return _REF_BOOKS
    }
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_POST_IMAGES: FIRStorageReference {
        return _REF_POST_IMAGES
    }
    
    var REF_USER_CURRENT: FIRDatabaseReference {
        //needs to be safer
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!)
    
        //let user = REF_USERS.child("x001")
                //user.setValue(post)
        return user
    }
    
    var REF_USER_CURRENT_BOOKS: FIRDatabaseReference {
        let myBooks = REF_USER_CURRENT.child("myBooks")
        return myBooks 
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
   
}
