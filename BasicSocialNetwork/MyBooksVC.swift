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

class MyBooksVC: UIViewController, UICollectionViewDelegate, UISearchBarDelegate, UICollectionViewDataSource, UIPopoverPresentationControllerDelegate,UISearchResultsUpdating {
   
   
    @IBAction func unwindToMyBooks(segue: UIStoryboardSegue) {
        
    }
    
    @IBOutlet weak var searchBarPlaceHolder:UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func segmentedControlValueChanged(_ sender: AnyObject) {
       // resultsSearchController.isActive = false
        collectionView.reloadData()
    }
    
  
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        collectionView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       // resultsSearchController.isActive = false
        if segue.identifier == SEGUE_TO_BOOK_DETAILS {
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
    
    
    var resultsSearchController:UISearchController = UISearchController(searchResultsController: nil)
    var filteredBooks = [Book]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        self.resultsSearchController.searchResultsUpdater = self
        self.resultsSearchController.dimsBackgroundDuringPresentation = false
        self.resultsSearchController.hidesNavigationBarDuringPresentation = false
        resultsSearchController.searchBar.delegate = self
    
        resultsSearchController.searchBar.placeholder = "Find books in my list"
        
       // self.resultsSearchController.hides
     
       
        //self.view.addSubview(resultsSearchController.searchBar)
        // self.resultsSearchController.searchBar.transform.translatedBy(x: 0, y: 50)
        
    
        //navigationController?.navigationBar.addSubview(resultsSearchController.searchBar)
        self.resultsSearchController.searchBar.sizeToFit()
        searchBarPlaceHolder.addSubview(resultsSearchController.searchBar)
        
        self.definesPresentationContext = true      //  automaticallyAdjustsScrollViewInsets = false
       // definesPresentationContext = true
        
      //  self.collectionView.reloadData()
        
    }
    func updateCollectionView() {
        User.resetBooks()
        DataService.ds.REF_USER_CURRENT_BOOKS.observeSingleEvent(of: .value, with: {(snapshot) in
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
                            self.collectionView.reloadData()
                        }
                        
                    })
                    
                }
            }
        })

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        updateCollectionView()
        // self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(self.resultsSearchController.isActive) {
            return self.filteredBooks.count
        }
        else {
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
    }
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as? BookCell {
            if self.resultsSearchController.isActive {
                myCell.configureCell(book: filteredBooks[indexPath.row])
            }
            else {
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
            }
            return myCell
        }
        else {
            return UICollectionViewCell()
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filteredBooks.removeAll(keepingCapacity: false)
        
        var array = [Book]()
        switch(segmentedControl.selectedSegmentIndex)
        {
        case 0:
                array = User.haveReadBooks
            break
        case 1:
                array = User.amReadingBooks
            break
        case 2:
                array = User.wantToReadBooks
            break
        default:
            break
        }

        filteredBooks = array.filter {
            $0.title?.range (of: searchController.searchBar.text!, options: .caseInsensitive) != nil
        }
        
        if searchController.searchBar.text != "" {
            collectionView.reloadData()
        }
        
    }
    
    var isAscending: Bool = false
    
    @IBOutlet weak var sortButton: UIButton!
    @IBAction func onSort(_ sender: AnyObject) {
        
        
        if isAscending == false {
            isAscending = true
        }
        else {
            isAscending = false
            
        }
    
        User.sortBooks(isAscending: isAscending)
        collectionView.reloadData()
        sortButton.transform = sortButton.transform.scaledBy(x: 1, y: -1)
    }
    
   
}
