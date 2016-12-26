//
//  Post.swift
//  BasicSocialNetwork
//
//  Created by admin on 10/24/16.
//  Copyright © 2016 gdw. All rights reserved.
//

import Foundation
import Firebase
class Post {
    private var _caption: String!
    private var _imageURL: String!
    private var _likes: Int!
    private var _postKey: String!
    private var _postRef: FIRDatabaseReference!
    
    var caption: String {
        return _caption
    }
    
    var imageURL: String {
        return _imageURL
    }
    
    var likes: Int {
        return _likes
    }
    
    var postKey: String {
        return _postKey
    }
    
    init(caption: String, imageUrl: String, likes: Int) {
        self._caption = caption
        self._imageURL = imageUrl
        self._likes = likes
        print("GW: post init called")
  
    }
    
    init(postKey: String, postData: Dictionary<String, AnyObject>) {
        
        self._postKey = postKey
        _postRef = DataService.ds.REF_POSTS.child(_postKey)
        
        if let caption = postData["caption"] as? String{
            self._caption = caption
        }
        
        if let imageURL = postData["imageURL"] as? String {
            self._imageURL = imageURL
        }
        
        if let likes = postData["likes"] as? Int{
            self._likes = likes
        }
    }
    
    func adjustLikes(addLike: Bool) {
        if addLike {
            _likes = _likes + 1
        } else {
            _likes = _likes - 1
        }
        _postRef.child("likes").setValue(_likes) 
    }
}
