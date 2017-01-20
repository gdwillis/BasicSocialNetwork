//
//  ViewController.swift
//  BasicSocialNetwork
//
//  Created by admin on 10/18/16.
//  Copyright © 2016 gdw. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import SwiftKeychainWrapper

class SigninVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        // Do any additional setup after loading the view, typically from a nib.
    }
    //GW: segues must be performed in viewDidAppear. viewDidLoad is to late
    override func viewDidAppear(_ animated: Bool) {
        //if sign in credentials are saved skip sign in view
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: SEGUE_TO_FEED, sender: nil)
        }
    }
    @IBAction func facebookButtonTapped(_ sender: AnyObject) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("GW: Unable to authenticate with Facebook -\(error)")
            } else if result?.isCancelled == true {
                print("GW: user canceled facebook authentication")
            } else {
                print("GW: Successfully authenticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
        
    }

    //GW: for facebook auth
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                //GW: GoogleSerivce-info.plist sometimes has the API_KEY field missing. If this error is thrown saying wrong api key try downloading a new plist from firebase
               print("GW: unable to authenticate -\(error)")
            }else {
                print("GW: Successfully authenticated with Firebase")
                if let user = user {
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
            }
        })
    }
        
    @IBOutlet weak var passwordTextField: FancyField!
    @IBOutlet weak var emailTextField: FancyField!
    @IBAction func signInTapped(_ sender: AnyObject) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    print("GW: Email user authenticated with Firebase")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }

                } else {
                    print("GW: \(error)")
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: {(user, error) in
                        if error != nil {
                            print("GW: unable to authenticate with firebase using email \(error)")
                        } else {
                            print("GW: Succesfully authenticated with firebase")
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
                        }
                        })
                }
            })
        }
    }

    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("GW: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: SEGUE_TO_FEED, sender: nil)
    }

}

