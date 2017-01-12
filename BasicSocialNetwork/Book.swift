//
//  Book.swift
//  BasicSocialNetwork
//
//  Created by admin on 11/13/16.
//  Copyright © 2016 gdw. All rights reserved.
//

import Foundation
import Firebase
import AlamofireImage
import Alamofire

class Book {
    private let usersMyBooksRef = DataService.ds.REF_USER_CURRENT_BOOKS
    private var _isManualyAdded: Bool = false
    private var _bookRef: FIRDatabaseReference?
    private var _title: String?
    private var _authors: [String]?
    private var _bookKey: String?
    private var _category: String?
    private var _volumeInfo: Dictionary<String, AnyObject>?
    private var _publisher: String?
    private var _review: Double?
    private var _pageNumber: Int?
    private var _thumbnailURL: String?
    private var _largeImageURL: String?
    private var _description: String?
    private var _date: String?
    private var _genres: [String]?
    private let imageCache = AutoPurgingImageCache(memoryCapacity: 100_000_000, preferredMemoryUsageAfterPurge: 60_000_000)
    
    
    
    var title: String? {
        return _title
    }
    
    var description:String? {
        return _description
    }
    
    var authors: [String]? {
        return _authors
    }
    
    var genres: [String]? {
        return _genres
    }
    
    var bookKey: String? {
        return _bookKey
    }
    
    var category: String? {
        return _category
    }
    var review: Double? {
        return _review
    }
    var pageNumber: Int? {
        return _pageNumber
    }
    var publisher: String? {
        return _publisher
    }
    var date: String? {
        return _date
    }
    
    
    func setCategory(newCategory: String) {
        _category = newCategory
    }
    //for myBooksVC
    init(bookKey: String, bookData: Dictionary<String, AnyObject>, category: String) {
        
        self._bookKey = bookKey
        _category = category
        if let isManualyAdded = bookData["isManualyAdded"] as? Bool {
            _isManualyAdded = isManualyAdded
        }
        //  print("book class key: \(DataService.ds.REF_BOOKS.child(self._bookKey).value)")
        parseVolumeInfo(volumeInfo: bookData)
         _bookRef = DataService.ds.REF_BOOKS.child(_bookKey!)
    }
    //for addBook manualy
    init(title: String, authors: [String], id: String, category: String) {
        
        self._bookKey = id
        _category = category
        self._title = title
        self._authors = authors
        self._isManualyAdded = true
        
        _bookRef = DataService.ds.REF_BOOKS.child(_bookKey!)
    }
    //for booksearch
    init(volume: Dictionary<String, AnyObject>) {
        
        let id = volume["id"] as? String
        
        self._bookKey = id//bookKey
        _category = AM_READING
        _volumeInfo = volume["volumeInfo"] as? Dictionary<String, AnyObject>
        if let volumeInfo = _volumeInfo {
            parseVolumeInfo(volumeInfo: volumeInfo)
        }
        _bookRef = DataService.ds.REF_BOOKS.child(_bookKey!)
    }
    
    private func parseVolumeInfo(volumeInfo: Dictionary<String, AnyObject>) {
        
        let publisher = volumeInfo["publisher"] as? String
        let date = volumeInfo["publishedDate"] as? String
        let pageNumber = volumeInfo["pageCount"] as? Int
        let review = volumeInfo["averageRating"] as? Double
        let title = volumeInfo["title"] as? String
        let authors = volumeInfo["authors"] as? [String]
        let genres = volumeInfo["categories"] as? [String]
        let thumbnailURL = volumeInfo["imageLinks"]?["smallThumbnail"] as? String
        let largeImageURL = volumeInfo["imageLinks"]?["thumbnail"] as? String
        let description = volumeInfo["description"] as? String
        _title = title
        _authors = authors
        _genres = genres
        _thumbnailURL = thumbnailURL
        _largeImageURL = largeImageURL
        _description = description
        self._title = title
        self._authors = authors
        _review = review
        _pageNumber = pageNumber
        _date = date
        _publisher = publisher

    }
    func serializeUsersMyBooks() -> Dictionary<String, String>
    {
        let dictionary = [_bookKey!: _category!]
        return dictionary
    }
    func setThumbnailsURL(thumbnailURL:String) {
        _thumbnailURL = thumbnailURL
        _largeImageURL = thumbnailURL 
    }
    func serializeBooks() -> Dictionary<String, Any> {
        
        var dictionary = Dictionary<String, Any>()
        if _isManualyAdded {
            var imageLinks = Dictionary<String, Any>()
            imageLinks["smallThumbnail"] = _thumbnailURL
            imageLinks["thumbnail"] = _largeImageURL
            dictionary = ["title": _title!, "authors": _authors!, "imageLinks": imageLinks, "isManualyAdded": true]
        }
        else {
            if let volumeInfo = _volumeInfo {
                dictionary = volumeInfo
            }
            /*
            let imageLinks = _volumeInfo?["imageLinks"] as? Dictionary<String, AnyObject>
            dictionary ["averageRating"] = _review
            dictionary["title"] = _title
            dictionary["authors"] = _authors
            dictionary["publisher"] = _publisher
            dictionary["publishedDate"] = _date
            dictionary["pageCount"] = _pageNumber
            dictionary["averageRating"] = _review
            dictionary["categories"] = _genres
            dictionary["imageLinks"] = imageLinks
            dictionary["description"] = _description
            
            //Note to self: dictionarys in swift can contain nil values if initialized in the manner bellow. Otherwise if a value is nil it will automaticaly be removed from the dictionary.
            //dictionary = ["title": _title, "authors": _authors, "publisher": _publisher, "publishedDate": _date,  "pageCount": _pageNumber, "averageRating": _review, "categories": _genres, "imageLinks": imageLinks, "description": _description]
            */
        }
        return dictionary
        
    }
    
   
    
    public func updateUsersMyBooks() {
   
        usersMyBooksRef.updateChildValues(self.serializeUsersMyBooks())
    }
    
    func removeBook () {
        
        if _isManualyAdded {
            _bookRef?.removeValue()
        }
        
        usersMyBooksRef.child(_bookKey!).removeValue()
      //
    }
    
    func addBookToBookRef() {
        
        _bookRef?.setValue(self.serializeBooks())
        self.updateUsersMyBooks()
    }
    
    private func cacheImage(image: Image, urlString: String) {
        imageCache.add(image, withIdentifier: urlString)
    }
    
    private func getImageFromCache(imageURL: String?) -> UIImage? {
        if let urlString = imageURL {
            return imageCache.image(withIdentifier: urlString)
        }
        else {
            return nil
        }
    }
    
    func getImageFromGoogle(imageView: UIImageView, activityIndicator: UIActivityIndicatorView, isThumbnail: Bool) {
        
        var imageURL: String?
        if isThumbnail {
            imageURL = _thumbnailURL
        }
        else {
            imageURL = _largeImageURL
        }
        
        if let image = getImageFromCache(imageURL: imageURL) {
            imageView.image = image
            print("GW: image came from cache")
        } else {
            imageView.isHidden = true
            activityIndicator.startAnimating()
            
            if let url = imageURL {
                //get image from firebase
            if _isManualyAdded {
                let ref = FIRStorage.storage().reference(forURL: url)
                ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                    if error != nil {
                        print("GW Unable to download image from Firebase storage: \(error)")
                        activityIndicator.stopAnimating()
                        imageView.isHidden = false
                        imageView.image = #imageLiteral(resourceName: "devslopes")
                    } else {
                        print("GW image downloaded succesfully from fb storage")
                        if let imgData = data {
                            if let image = UIImage(data: imgData) {
                                activityIndicator.stopAnimating()
                                imageView.image = image
                                self.cacheImage(image: image, urlString: url)
                                imageView.isHidden = false
                            }
                        }
                    }
                })
                }
                //get image from google
            else {
                Alamofire.request(url).responseImage(completionHandler: {(response) in                    if let image = response.result.value {
                    activityIndicator.stopAnimating()
                    imageView.image = image
                    self.cacheImage(image: image, urlString: url)
                    imageView.isHidden = false
                }
                else {
                    print("GW: almofireimage was not successful")
                    }
                })
                }
            }
            else {
                //google books did not have a image so use a default image
                activityIndicator.stopAnimating()
                imageView.isHidden = false
                imageView.image = #imageLiteral(resourceName: "devslopes")
            }
            
        }
    }
    func getSegmentedControlIndex() -> Int{
        if let category = self.category {
        switch(category)
        {
        case HAVE_READ:
            return 0
        case AM_READING:
            return 1
        case WANT_TO_READ:
            return 2
        default:
            break
        }
    }
        
        return 0
    
    }

}
