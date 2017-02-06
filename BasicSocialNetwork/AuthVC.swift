//
//  AuthVC.swift
//  BasicSocialNetwork
//
//  Created by admin on 2/5/17.
//  Copyright © 2017 gdw. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import GoogleSignIn
import Firebase

class AuthVC: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {

    @IBAction func unwindToAuth(segue: UIStoryboardSegue) {
        
    }
    
    @IBOutlet weak var container: UIView!
    override func viewWillAppear(_ animated: Bool) {
        //if sign in credentials are saved skip sign in view
        view.viewWithTag(-1)?.isHidden = true
        if KeychainWrapper.standard.string(forKey: KEY_UID) == nil {
            container.isHidden = false
        }
    }

   
    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: SEGUE_TO_FEED, sender: nil)
                  self.container.isHidden = true
            }
          
            
        }
        else {
            self.container.isHidden = false
        }
        
        // Do any additional setup after loading the view.
    }

   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            // ...
            print(error.localizedDescription)
            return
        }
        
        view.viewWithTag(-1)?.isHidden = false
        let authentication = user.authentication
        let credential = FIRGoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!, accessToken: (authentication?.accessToken)!)
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                self.view.viewWithTag(-1)?.isHidden = true
                return
            }
            if let user = user {
                let userData = ["provider": credential.provider]
                self.completeSignIn(id: user.uid, userData: userData)
            }
            
            print("user logged in with google...")
        })
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
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("GW: Data saved to keychain \(keychainResult)")
        print("firebaseid: \(id)")
        performSegue(withIdentifier: SEGUE_TO_FEED, sender: nil)
        
        
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
