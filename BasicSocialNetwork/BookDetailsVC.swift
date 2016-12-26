//
//  BookDetailsVC.swift
//  BasicSocialNetwork
//
//  Created by admin on 12/8/16.
//  Copyright © 2016 gdw. All rights reserved.
//

import UIKit

class BookDetailsVC: UIViewController {

    @IBOutlet weak var descriptionHeader: UILabel!
    @IBOutlet weak var reviewsHeader: UILabel!
    @IBOutlet weak var genreHeader: UILabel!
    @IBOutlet weak var pagesHeader: UILabel!
    @IBOutlet weak var dateHeader: UILabel!
    @IBOutlet weak var publisherHeader: UILabel!
    @IBOutlet weak var authorHeader: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ReviewsLabel: UILabel!
    @IBOutlet weak var pageNumberLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    var book: Book!
    var hasAddButton: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        if hasAddButton {
            addButton.isHidden = false
        }
        else {
            addButton.isHidden = true
        }
        
        titleLabel.text = book.title
        
        if let authors = book.authors {
            var text = ""
            authorLabel.numberOfLines = authors.count
            for author in authors {
                text += "\(author)\n"
                authorLabel.text = text
            }
        }
        
        if authorLabel.text == "Author" {
            authorLabel.text = ""
        }
        if let genres = book.genres {
            var text = ""
            genreLabel.numberOfLines = genres.count
            for genre in genres {
                text += "\(genre)\n"
                genreLabel.text = text
            }
        }
        
        if genreLabel.text == "Genre" {
            genreLabel.text = ""
        }
    
        descriptionLabel.text = book.description
        publisherLabel.text = book.publisher
        dateLabel.text = book.date
        if let review = book.review {
            ReviewsLabel.text = "\(review)/5.0"
        }
        else {
            ReviewsLabel.text = ""
        }
        if let pageNumber = book.pageNumber {
            pageNumberLabel.text = String(pageNumber)
        }
        else {
            pageNumberLabel.text = ""
        }
        
        book.getImageFromGoogle(imageView: thumbnail, activityIndicator: activityIndicator, isThumbnail: false)
        hideLabels()
        // Do any additional setup after loading the view.
    }

    private func hideLabels() {
        if ReviewsLabel.text == ""
        {
            reviewsHeader.isHidden = true
        }
        else {
             reviewsHeader.isHidden = false
        }
        
        if pageNumberLabel.text == ""
        {
            pagesHeader.isHidden = true
        }
        else {
            pagesHeader.isHidden = false
        }
        
        if publisherLabel.text == nil {
            publisherHeader.isHidden = true
        }
        else {
            publisherHeader.isHidden = false
        }
        
        if genreLabel.text == "" {
            genreHeader.isHidden = true
        }
        else {
            genreHeader.isHidden = false
        }
        
        if authorLabel.text == "" {
            authorHeader.isHidden = true
        }
        else {
            authorHeader.isHidden = false
        }
        
        if dateLabel.text == nil {
            dateHeader.isHidden = true
        } else {
            dateHeader.isHidden = false
        }
        
        if descriptionLabel.text == nil {
            descriptionHeader.isHidden = true
        } else {
            descriptionHeader.isHidden = false
        }
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SEGUE_TO_MOVE_ADD_BOOK {
            let destination = segue.destination as! BookUpdateVC
            destination.book = book
            destination.isAdding = true
        }
    }
    
    
}
