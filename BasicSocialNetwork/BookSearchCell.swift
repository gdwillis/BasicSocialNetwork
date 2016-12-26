//
//  SearchCell.swift
//  BasicSocialNetwork
//
//  Created by admin on 11/30/16.
//  Copyright © 2016 gdw. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class BookSearchCell:UITableViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var thumbnail: UIImageView!
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
   
    @IBOutlet weak var titleLabel: UILabel!
 
    private var _book: Book!
    
    var book:Book {
        return _book
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell (book:Book) {
   
        _book = book
        if let authors = _book.authors {
            var text = ""
            authorLabel.numberOfLines = authors.count
            for author in authors {
                text += "\(author)\n"
                authorLabel.text = text
            }
        }
        titleLabel.text = book.title
        descriptionLabel.text = book.description
        _book.getImageFromGoogle(imageView: thumbnail, activityIndicator: activityIndicator, isThumbnail: true)
    }
    
    
}
