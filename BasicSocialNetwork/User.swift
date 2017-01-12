//
//  User.swift
//  BasicSocialNetwork
//
//  Created by admin on 12/25/16.
//  Copyright © 2016 gdw. All rights reserved.
//

import Foundation

class User {
    static var haveReadBooks : [Book] = []
    static var amReadingBooks : [Book] = []
    static var wantToReadBooks : [Book] = []
    static var bookIds: [String] = [] 
    var userRef = DataService.ds.REF_USER_CURRENT
    
    static func resetBooks()
    {
        User.haveReadBooks = []
        User.amReadingBooks = []
        User.wantToReadBooks = [] 
    }
    
    static func sortBooks()
    {
        
        haveReadBooks.sort(by:{
            var b = false
            if $0.title != nil && $1.title != nil { b = $0.title! < $1.title! }
            return b
            
        })
        
        amReadingBooks.sort(by:{
            var b = false
            if $0.title != nil && $1.title != nil { b = $0.title! < $1.title! }
            return b
            
        })
        
        wantToReadBooks.sort(by:{
            var b = false
            if $0.title != nil && $1.title != nil { b = $0.title! < $1.title! }
            return b
            
        })
        
    }
}
