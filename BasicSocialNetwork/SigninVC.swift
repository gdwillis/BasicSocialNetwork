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


class SigninVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passwordValidater: UILabel!
    @IBOutlet weak var emailValidater: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    
    @IBAction func onBackBtn(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    
    let movieTransitionDelegate = MovieTransitionDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.delegate = self
        emailTextField.delegate = self
      
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {

        self.errorLabel.isHidden = true
        forgotPasswordBtn.isHidden = true
    }
    //GW: segues must be performed in viewDidAppear. viewDidLoad is to late
   
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
    
  
    func showOverlayFor () {
        let sb = UIStoryboard(name: "Main", bundle:nil)
        
        transitioningDelegate = movieTransitionDelegate
       
            let overlayVC = sb.instantiateViewController(withIdentifier: "GoogleSignIn") as! GooglePopupVC
        
            overlayVC.completeSignIn = completeSignIn
         
        
        
        overlayVC.transitioningDelegate = movieTransitionDelegate
            overlayVC.modalPresentationStyle = .custom
            
            self.present(overlayVC, animated: true, completion: nil)
    }
    
    @IBOutlet weak var passwordTextField: FancyField!
    @IBOutlet weak var emailTextField: FancyField!
    @IBAction func signInTapped(_ sender: AnyObject) {
        forgotPasswordBtn.isHidden = true
        errorLabel.text = ""
        errorLabel.isHidden = true
        if let email = emailTextField.text, let password = passwordTextField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if error != nil{
                    let error = error! as NSError
                    let errCode = FIRAuthErrorCode(rawValue: error.code )
                    self.errorLabel.isHidden = false
                    if errCode == .errorCodeUserNotFound {
                        self.errorLabel.text = "Error: User not found"
                    }
                    else if errCode == .errorCodeWrongPassword {
                        
                      
                        FIRAuth.auth()?.fetchProviders(forEmail: email, completion: {providers, error in
                            if let providers = providers {
                                
                                if providers.contains(FIRGoogleAuthProviderID) {
                                    
                                    self.showOverlayFor()
                                }
                                else {
                                    self.errorLabel.text = "Error: Wrong Password"
                                    
                                    self.forgotPasswordBtn.isHidden = false
                                }
                            }
                            else {
                                self.errorLabel.text = "Error: Something went wrong please try again at a later time"
                            }
                        })
                    }
                    else if errCode == .errorCodeUserDisabled{
                          self.errorLabel.text = "Error: User account is disabled"
                    }
                   
                    else {
                        self.errorLabel.text = "Error: Something went wrong please try again at a later time"
                    }


                } else {
                    print("GW: Email user authenticated with Firebase")
                 
                    
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                                   }
            })
        }
    }

    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("GW: Data saved to keychain \(keychainResult)")
        print("firebaseid: \(id)")
        performSegue(withIdentifier: SEGUE_TO_FEED, sender: nil)
        
        
    }
    
       override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return  true
    }

}

