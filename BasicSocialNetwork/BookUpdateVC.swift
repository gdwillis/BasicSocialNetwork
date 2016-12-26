//
//  MoveBookVC.swift
//  BasicSocialNetwork
//
//  Created by admin on 11/19/16.
//  Copyright © 2016 gdw. All rights reserved.
//

import UIKit

class BookUpdateVC: UIViewController {
    
    @IBOutlet weak var delete: UIButton!
    var book: Book!
    var isAdding: Bool = false
    
    @IBOutlet weak var header: UILabel!
    @IBAction func haveRead(_ sender: AnyObject) {
        updateBook(category: HAVE_READ)
    }
    
    @IBAction func wantToRead(_ sender: AnyObject) {
        updateBook(category: WANT_TO_READ)
    }
    @IBAction func amReading(_ sender: AnyObject) {
        updateBook(category: AM_READING)
    }
    @IBAction func dismiss(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
   
    private func updateBook(category: String) {
    
        book.setCategory(newCategory: category)
        
        if isAdding {
            book.addBookToBookRef()
        }
        else {
            book.updateUsersMyBooks()
        }
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isAdding {
            header.text = "Add To:"
            delete.isHidden = true
        }
        else {
            header.text = "Move To:"
            delete.isHidden = false 
        }
        // Do any additional setup after loading the view.
    }
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SEGUE_TO_CONFIRM_DELETE {
            let destination = segue.destination as! ConfirmDeleteBookVC
            destination.book = book
            destination.sendersVC = self
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
