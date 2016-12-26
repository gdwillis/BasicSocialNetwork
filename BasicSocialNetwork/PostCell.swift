//
//  PostCell.swift
//  BasicSocialNetwork
//
//  Created by admin on 10/23/16.
//  Copyright © 2016 gdw. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {

    
    @IBOutlet weak var likeImage: CircileView!
    @IBOutlet weak var likeLabel: UILabel!
    
    var post: Post!
    var likesRef: FIRDatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImage.addGestureRecognizer(tap)
        likeImage.isUserInteractionEnabled = true
        // Initialization code
    }

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLable: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLable: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
       
        likesRef.observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImage.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(addLike: true)
                self.likesRef.setValue(true)
            } else {
                self.likeImage.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: false)
                self.likesRef.removeValue()
            }
        })
    }
    
    func configureCell(post: Post, image: UIImage? = nil) {
        self.post = post
        likesRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        self.caption.text = post.caption
        self.likesLable.text = "\(post.likes)"
        
        if image != nil {
            self.postImage.image = image
            print("GW image came from cache")
        } else {
                let ref = FIRStorage.storage().reference(forURL: post.imageURL)
                ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                    if error != nil {
                        print("GW Unable to download image from Firebase storage: \(error)")
                    } else {
                        print("GW image downloaded succesfully from fb storage")
                        if let imgData = data {
                            if let img = UIImage(data: imgData) {
                                self.postImage.image = img
                                FeedVC.imageCache.setObject(img, forKey: post.imageURL as NSString)
                            }
                        }
                    }
            })
        }
        
        likesRef.observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImage.image = UIImage(named: "empty-heart")
            } else {
                self.likeImage.image = UIImage(named: "filled-heart")
            }
        })
    }
    
   

}
