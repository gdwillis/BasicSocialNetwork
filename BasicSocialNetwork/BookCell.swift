//
//  BookCellTableViewCell.swift
//  BasicSocialNetwork
//
//  Created by admin on 11/17/16.
//  Copyright © 2016 gdw. All rights reserved.
//

import UIKit

class BookCell: UICollectionViewCell {

    private var _book: Book!
    
    var book: Book {
        return _book
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    
    func configureCell(book: Book)
    {
        _book = book
       // titleLabel.text = _book.bookKey
        titleLabel.text = _book.title
       // if let authors = _book.authors {
         //   var text = ""
           // authorLabel.numberOfLines = authors.count
           // for author in authors {
           //     text += "\(author)\n"
           //     authorLabel.text = text
          //  }
        //}
        
        //this should return image back and bookCell sets it
        _book.getImageFromGoogle(imageView: thumbnail, activityIndicator: activityIndicator, isThumbnail: true)
    }

   
}
