//
//  MyBooksVC.swift
//  BasicSocialNetwork
//
//  Created by admin on 11/12/16.
//  Copyright © 2016 gdw. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper
import Alamofire

class MyBooksVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate {
    
    
    @IBAction func segmentedControlValueChanged(_ sender: AnyObject) {
        tableView.reloadData()
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SEGUE_TO_MOVE_ADD_BOOK {
            let button = sender as! UIButton
            let view = button.superview!
            let cell = view.superview as! BookCell
            let destination = segue.destination as! BookUpdateVC
            destination.book = cell.book
            destination.isAdding = false
        }
        else if segue.identifier == SEGUE_TO_BOOK_DETAILS {
            let destination = segue.destination as! BookDetailsVC
            destination.hasAddButton = false
            let cell = sender as! BookCell
            destination.book = cell.book
        }
        //  }
        
        /*
         var popoverVC = vc.popoverPresentationController
         
         if popoverVC != nil
         {
         popoverVC?.delegate = self
         }
         */
        
        
    }
    /*
     func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
     return .none
     }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        DataService.ds.REF_USER_CURRENT_BOOKS.observe(.value, with: {(snapshot) in
            User.resetBooks()
            if let myBooks = snapshot.children.allObjects as? [FIRDataSnapshot] {
                var counter: Int = 0
                for book in myBooks {
                    let key = book.key
                    DataService.ds.REF_BOOKS.child(key).observeSingleEvent(of: .value, with: {(snapshot) in
                        let category = book.value as! String
                        let bookKey = snapshot.key
                        if let bookData = snapshot.value as? Dictionary<String, AnyObject> {
                            let thisBook = Book(bookKey: bookKey, bookData: bookData, category: category)
                           
                            
                        switch(thisBook.category!)
                        {
                        case  AM_READING:
                            
                           
                             User.amReadingBooks.append(thisBook)
                            
                            break;
                        case HAVE_READ:
                            
                            User.haveReadBooks.append(thisBook)
                         
                            
                            break
                        case WANT_TO_READ:
                            
                            User.wantToReadBooks.append(thisBook)
                            
                            break
                        default:
                            break
                            
                        }
                        }
                        counter += 1
                        //only reload data when observer finishes apending all books
                        if counter >= myBooks.count {
                            self.tableView.reloadData()
                        }
                        
                    })
                    
                }
            }
            
        })
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(segmentedControl.selectedSegmentIndex)
        {
        case 0:
            return User.haveReadBooks.count
        case 1:
            return User.amReadingBooks.count
        case 2:
            return User.wantToReadBooks.count
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let myCell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as? BookCell {
            switch(segmentedControl.selectedSegmentIndex)
            {
            case 0:
                myCell.configureCell(book: User.haveReadBooks[indexPath.row])
                break
            case 1:
                myCell.configureCell(book: User.amReadingBooks[indexPath.row])
                break
            case 2:
                myCell.configureCell(book: User.wantToReadBooks[indexPath.row])
                break
            default:
                break
            }
            
            return myCell
        }
        else {
            return UITableViewCell()
        }
    }
    
    
    
}
