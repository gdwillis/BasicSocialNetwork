//
//  SearchBookVC.swift
//  BasicSocialNetwork
//
//  Created by admin on 11/30/16.
//  Copyright © 2016 gdw. All rights reserved.
//

import UIKit
import Alamofire 

class BookSearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    private let SEARCH_LIMIT = 60
    private var startIndex = 0
    private var _volumes = Array<Dictionary<String, AnyObject>>()
    private var _books = [Book]()
    private var searchText: String!
    @IBAction func searchAction(_ sender: AnyObject) {
        self._volumes = []
        startIndex = 0
       
        if textField.text != ""
        {
            let specialCharacters = ["+": "%2B", "#": "%23", "!": "%21", "$": "%24", "&": "%26", "'": "%27", "(": "%28", ")": "%29", "*": "%2A", ",": "%2C", "/": "%2F", ":": "%3A", ";": "%3B", "=": "%3D", "?": "%3F", "@": "%40", "[": "%5B", "]": "%5D", " ": "+"]
            searchText = textField.text
            for (reserveChar, encodedChar) in specialCharacters {
                
                searchText = searchText.replacingOccurrences(of: reserveChar, with: encodedChar)
            }
            
            searchGoogleAPI(isNewSearch: true)
           
        }
        else {
            print("GW: user needs to enter something")
            return
        }
  
    }
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self._books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let myCell = tableView.dequeueReusableCell(withIdentifier: BOOK_SEARCH_CELL, for: indexPath) as? BookSearchCell {
            if(indexPath.row < _books.count) {
                myCell.configCell(book: _books[indexPath.row])
            }
            return myCell
        }
        else {
            return UITableViewCell()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       
        
        if segue.identifier == SEGUE_TO_MOVE_ADD_BOOK {
        let button = sender as! UIButton
        let view = button.superview!
        let cell = view.superview?.superview?.superview as! BookSearchCell
        let destination = segue.destination as! BookUpdateVC
        destination.book = cell.book
        destination.isAdding = true
        }
        else if segue.identifier == SEGUE_TO_BOOK_DETAILS {
            let destination = segue.destination as! BookDetailsVC
            let cell = sender as! BookSearchCell
            destination.hasAddButton = true
            destination.book = cell.book 
        }
        
    }
 
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = _books.count - 1
        if indexPath.row == lastElement && lastElement >= startIndex + MAX_RESULTS - 1{
            startIndex += MAX_RESULTS
            if _volumes.count <= SEARCH_LIMIT
            {
                searchGoogleAPI(isNewSearch: false)
            }
            print("startindex: \(startIndex)")
            print("volume: \(_volumes.count)")
        }

    }
    func searchGoogleAPI(isNewSearch: Bool) {
        var searchBy: String!
        switch(segmentedControl.selectedSegmentIndex)
        {
        case 0:
            searchBy = INTITLE
        case 1:
            searchBy = INAUTHOR
        case 2:
            searchBy = SUBJECT
        default:
            break
        }

        let baseURL = BASE_SEARCH_URL + searchBy + searchText! + GOOGLE_APIKEY + PARTIAL_RESPONSE
        let requestURL = baseURL + MAX_RESULTS_STRING + "\(MAX_RESULTS)" + START_INDEX + "\(startIndex)"
     //   print("\(requestURL)")
        _books = []
        Alamofire.request(requestURL).responseJSON(completionHandler: { response in
            let result = response.result.value
            if let dict = result as? Dictionary<String, AnyObject> {
                if let items = dict["items"] as? NSArray {
                    for item in items {
                        if let volume = item as? Dictionary<String, AnyObject> {
                            //memory leak issue
                            self._volumes.append(volume)
                            
                        }
                    }
                    
                }
            }
            //if request was successful volumes should not be empty
            if !self._volumes.isEmpty {
                for volume in self._volumes {
                    let book = Book(volume: volume)
                    
                    if book.bookKey != nil {
                        self._books.append(book)
                    }
                    else {
                        print("Google API did not have a book id for this book. Books without an id will not show up in our search")
                    }
                }
                self.tableView.reloadData()
                //scroll to top if user entered a new search
                if isNewSearch {
                let indexPath = IndexPath(row: 0, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.middle, animated: false)
                }
            }
            else {
                print("GW: request faild to recieve volumeinfo")
            }
        })

    }
    }
