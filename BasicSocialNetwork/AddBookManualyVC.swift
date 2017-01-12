//
//  AddBookViewController.swift
//  BasicSocialNetwork
//
//  Created by admin on 11/29/16.
//  Copyright © 2016 gdw. All rights reserved.
//

import UIKit
import Firebase

class AddBookManualyVC: UIViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imageSelected = false
    
    
    var imagePicker: UIImagePickerController!
  
    
    @IBAction func addThumbnail(_ sender: AnyObject) {
          present(imagePicker, animated: true, completion: nil)
    }
    
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var authorField: UITextField!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBAction func addButton(_ sender: AnyObject) {
        if titleField.text == "" {
            titleLabel.text = "Please enter a title"
            return
        }
        if authorField.text == "" {
            authorLabel.text = "Please enter a author"
            return
        }
        
        let title = titleField.text
        let author = authorField.text
        var authors = [String]()
        authors.append(author!)
        let categoryIndex = segmentedControl.selectedSegmentIndex
        var category = ""
        if categoryIndex == 0 {
            category = AM_READING
        }
        else if categoryIndex == 1 {
            category = HAVE_READ
        }
        else if categoryIndex == 2 {
            category = WANT_TO_READ
        }
        
        /*var bookKey = ""
        if title != nil && author != nil {
            bookKey = title!.lowercased()+" "+author!.lowercased()
        }
        else if title != nil {
            bookKey = title! + bookKey
        }*/
      /*  let invalidCharacters = [".", "$", "[", "]", "#","/"]
        
        //remove firebase invalid characters for key
        for character in invalidCharacters {
            //print(character)
            bookKey = bookKey.replacingOccurrences(of: character, with: "")
        }*/

        let bookKey = UUID().uuidString
        
        let book = Book(title: title!, authors: authors, id: bookKey, category: category)
        
        if let img = imageOutlet.image, imageSelected == true {
        if let imageData = UIImageJPEGRepresentation(img, 0.2) {
            let imageUID = "\(NSUUID().uuidString)"
            let metadata = FIRStorageMetadata()
            metadata.contentType = "Image/jpeg"
            
            DataService.ds.REF_POST_IMAGES.child(imageUID).put(imageData, metadata: metadata) { (metadata, error) in
                if error != nil{
                    print("GW: Unable to upload image to Firebase storage \(error)")
                    book.addBookToBookRef()
                } else {
                    print("GW: Successfull uploaded image to Firebase storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        book.setThumbnailsURL(thumbnailURL: url)
                        self.imageSelected = false
                        book.addBookToBookRef()
                    }
                }
            }
        }
        else {
            book.addBookToBookRef()
            }
        }
        else {
            book.addBookToBookRef()
        }
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageOutlet.image = image
            imageSelected = true
        } else {
            print("GW: A valid image wasn't selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
