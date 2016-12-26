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
    
}
