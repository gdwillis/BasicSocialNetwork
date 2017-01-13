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
    
    static func sortBooks(isAscending: Bool)
    {
        let sortClousure = { (b0:Book, b1:Book) -> Bool in
            var flag = false
            if isAscending {
                if b0.title != nil && b1.title != nil { flag = b0.title! < b1.title! }
            }
            else {
                 if b0.title != nil && b1.title != nil { flag = b0.title! > b1.title! }
            }
            return flag
        }
        
        haveReadBooks.sort(by:{
            
            sortClousure($0, $1)
        })
        
        amReadingBooks.sort(by:{
            sortClousure($0, $1)
            
        })
        
        wantToReadBooks.sort(by:{
            sortClousure($0, $1)
            
        })
        
    }
}
