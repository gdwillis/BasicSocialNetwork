//
//  AddBookViewController.swift
//  BasicSocialNetwork
//
//  Created by admin on 11/29/16.
//  Copyright © 2016 gdw. All rights reserved.
//

import UIKit

class AddBookManualyVC: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var authorField: UITextField!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBAction func addButton(_ sender: AnyObject) {
        if titleField.text == "" {
            titleLabel.text = "Please enter a title"
            return
        }
        if authorField.text == "" {
            authorLabel.text = "Please enter a author"
            return
        }
        
        let title = titleField.text
        let author = authorField.text
        var authors = [String]()
        authors.append(author!)
        let categoryIndex = segmentedControl.selectedSegmentIndex
        var category = ""
        if categoryIndex == 0 {
            category = AM_READING
        }
        else if categoryIndex == 1 {
            category = HAVE_READ
        }
        else if categoryIndex == 2 {
            category = WANT_TO_READ
        }
        
        /*var bookKey = ""
        if title != nil && author != nil {
            bookKey = title!.lowercased()+" "+author!.lowercased()
        }
        else if title != nil {
            bookKey = title! + bookKey
        }*/
      /*  let invalidCharacters = [".", "$", "[", "]", "#","/"]
        
        //remove firebase invalid characters for key
        for character in invalidCharacters {
            //print(character)
            bookKey = bookKey.replacingOccurrences(of: character, with: "")
        }*/

        let bookKey = UUID().uuidString
        
        let book = Book(title: title!, authors: authors, id: bookKey, category: category)
        
        book.addBookToBookRef()
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
