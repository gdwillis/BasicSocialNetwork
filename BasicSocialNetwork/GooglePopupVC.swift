//
//  GooglePopupVC.swift
//  BasicSocialNetwork
//
//  Created by admin on 2/5/17.
//  Copyright © 2017 gdw. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase

class GooglePopupVC: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {

    var completeSignIn: ((String, Dictionary<String, String>) -> Void)!
    
    
    
    @IBAction func dismiss(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.view.bounds.size = CGSize(width: UIScreen.main.bounds.size.width - 20, height: 200)
        
        self.view.layer.cornerRadius = 5
        
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            // ...
            print(error.localizedDescription)
            return
        }
       
        
        let authentication = user.authentication
        let credential = FIRGoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!, accessToken: (authentication?.accessToken)!)
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let user = user {
                let userData = ["provider": credential.provider]
               self.completeSignIn(user.uid, userData)
            
            }
            
            print("user logged in with google...")
        })
        view.isHidden = true
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            // ...
            print(error.localizedDescription)
            return
        }
        print("GOOGLE SIGNED OUT!")
        GIDSignIn.sharedInstance().signOut()
        try! FIRAuth.auth()!.signOut()
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
