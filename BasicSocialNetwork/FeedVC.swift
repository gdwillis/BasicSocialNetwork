//
//  FeedVC.swift
//  BasicSocialNetwork
//
//  Created by admin on 10/21/16.
//  Copyright © 2016 gdw. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper
import Foundation

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var captionField: FancyField!
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    
    static var imageCache = NSCache<NSString, UIImage>()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageAdd: CircileView!
    
    @IBAction func postButtonTapped(_ sender: AnyObject) {
        guard let caption = captionField.text, caption != "" else {
            print("GW: caption must be entered")
            return
        }
        guard let img = imageAdd.image, imageSelected == true else {
            print("GW: An image must be selected")
            return
        }
        
        if let imageData = UIImageJPEGRepresentation(img, 0.2) {
            let imageUID = "\(NSUUID().uuidString)"
            let metadata = FIRStorageMetadata()
            metadata.contentType = "Image/jpeg"
            
            DataService.ds.REF_POST_IMAGES.child(imageUID).put(imageData, metadata: metadata) { (metadata, error) in
                if error != nil{
                    print("GW: Unable to upload image to Firebase storage")
                } else {
                    print("GW: Successfull uploaded image to Firebase storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        self.postToFirebase(imgUrl: url)
                    }
                }
            }
        }
    }
    
    @IBAction func imagePickerTapped(_ sender: AnyObject) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func signOutTapped(_ sender: AnyObject) {
        let keychainResult = KeychainWrapper.standard.remove(key: KEY_UID)
        print("GW: ID removed from keychian \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true 
        imagePicker.delegate = self
        
        DataService.ds.REF_POSTS.observe(.value, with: {(snapshot) in
            self.posts = [] 
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell
        {
            let post = posts[indexPath.row]
            if let image = FeedVC.imageCache.object(forKey: post.imageURL as NSString) {
                cell.configureCell(post: post, image: image)
                
            } else {
                cell.configureCell(post: post)
            }
            return cell
        }
        else {
            return PostCell()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAdd.image = image
            imageSelected = true
        } else {
            print("GW: A valid image wasn't selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func postToFirebase(imgUrl: String) {
        let post: Dictionary<String, Any> = [
            "caption": captionField.text!,
            "imageURL": imgUrl,
            "likes": 0
        ]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        captionField.text = ""
        imageSelected = false
        imageAdd.image = UIImage(named: "add-image")
        
        tableView.reloadData() 
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
