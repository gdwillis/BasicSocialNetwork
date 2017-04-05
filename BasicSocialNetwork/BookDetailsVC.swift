//
//  BookDetailsVC.swift
//  BasicSocialNetwork
//
//  Created by admin on 12/8/16.
//  Copyright © 2016 gdw. All rights reserved.
//

import UIKit

class BookDetailsVC: UIViewController {

    
    @IBOutlet weak var thumbnailContainer: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBAction func deleteAction(_ sender: Any) {
        showOverlayFor(isMove: false)
    }
    
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBAction func onAdd(_ sender: Any) {
         showOverlayFor(isMove: true
        )
    }
    
    
    @IBOutlet weak var descriptionHeader: UILabel!
    @IBOutlet weak var reviewsHeader: UILabel!
    @IBOutlet weak var genreHeader: UILabel!
    @IBOutlet weak var pagesHeader: UILabel!
    @IBOutlet weak var dateHeader: UILabel!
    @IBOutlet weak var publisherHeader: UILabel!
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
    
    let movieTransitionDelegate = MovieTransitionDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if hasAddButton {
            addButton.setTitle("Add", for: .normal)
            let margin = addButton.superview?.layoutMarginsGuide
            addButton.trailingAnchor.constraint(equalTo: (margin?.trailingAnchor)!).isActive = true
            
            
            deleteButton.isHidden = true
        }
        else {
            addButton.setTitle("Move", for: .normal)
            
            deleteButton.isHidden = false
        }
        
        titleLabel.text = book.title
        
        if let authors = book.authors {
            var text = "by: "
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
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.top = thumbnailContainer.frame.height
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
        // Do any additional setup after loading the view.
    }

    func showOverlayFor (isMove: Bool) {
        let sb = UIStoryboard(name: "Main", bundle:nil)
        
        transitioningDelegate = movieTransitionDelegate
        if isMove {
           let overlayVC = sb.instantiateViewController(withIdentifier: "UpdateBook") as! BookUpdateVC
            overlayVC.transitioningDelegate = movieTransitionDelegate
            overlayVC.modalPresentationStyle = .custom
            
            self.present(overlayVC, animated: true, completion: nil)
            overlayVC.isAdding = hasAddButton
            overlayVC.book = book
        }
        else {
            let overlayVC = sb.instantiateViewController(withIdentifier: "ConfrimDeleteBook") as! ConfirmDeleteBookVC
            
            overlayVC.transitioningDelegate = movieTransitionDelegate
            overlayVC.modalPresentationStyle = .custom
            
            self.present(overlayVC, animated: true, completion: nil)
            
            overlayVC.book = book
        }
        
      
    }
    
    private func hideLabels() {
        if ReviewsLabel.text == ""
        {
            ReviewsLabel.text = "N/A"
        }
        
        if pageNumberLabel.text == ""
        {
            pageNumberLabel.text = "N/A"
        }
        
        if publisherLabel.text == nil {
            publisherLabel.text = "N/A"
        }
        
        if genreLabel.text == "" {
            genreLabel.text = "N/A"
        }
        
        if dateLabel.text == nil {
            dateLabel.text = "N/A"
        }
        
        if descriptionLabel.text == nil {
            descriptionLabel.text = "N/A"
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
   /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SEGUE_TO_MOVE_ADD_BOOK {
            let destination = segue.destination as! BookUpdateVC
            destination.book = book
            destination.isAdding = hasAddButton
        }
    }*/
    
    
}
