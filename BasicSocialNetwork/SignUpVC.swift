//
//  SignUpVC.swift
//  BasicSocialNetwork
//
//  Created by admin on 2/4/17.
//  Copyright © 2017 gdw. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase
import SwiftKeychainWrapper

class SignUpVC: UIViewController, UITextFieldDelegate {
    
     let movieTransitionDelegate = MovieTransitionDelegate()
    
    @IBAction func onSignUp(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            errorLabel.text = ""
            errorLabel.isHidden = true
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: {(user, error) in
                if error != nil{
                    self.errorLabel.isHidden = false
                    let error = error! as NSError
                    let errCode = FIRAuthErrorCode(rawValue: error.code )
                    
                    if errCode == .errorCodeEmailAlreadyInUse{
                        FIRAuth.auth()?.fetchProviders(forEmail: email, completion: {providers, error in
                            if let providers = providers {
                                if providers.contains(FIRGoogleAuthProviderID) {
                                    
                                    self.showOverlayFor()
                                    print("gw providers: \(FIRGoogleAuthProviderID)")
                                }
                                else {
                                    self.errorLabel.text = "Error: This email is already in use"
                                }
                            }
                            else {
                                self.errorLabel.text = "Error: Something went wrong please try again later"
                            }
                        })
                    }
                    else if errCode == .errorCodeWeakPassword{
                        self.errorLabel.text = "Error: weak password, password must be at least 6 characters long"
                    }
                    else if errCode == .errorCodeInvalidEmail {
                        self.errorLabel.text = "Error: This is not a valid email" 
                    }
                    else {
                         self.errorLabel.text = "Error: Something went wrong please try again later"
                    }
                    
                    
                    
                    
                    // }
                    //else {
                    //     print("user is nil")
                    // }
                } else {
                    print("GW: Succesfully authenticated with firebase")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                }
            })
        }

    }
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var retypePasswordtextField: UITextField!
    @IBOutlet weak var retypePasswordValidate: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordValidate: UILabel!

    @IBOutlet weak var emailValidate: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
   
    @IBAction func onBackBtn(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordTextField.delegate = self
        emailTextField.delegate = self
        retypePasswordtextField.delegate = self
        //signInButton.text
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("GW: Data saved to keychain \(keychainResult)")
        print("firebaseid: \(id)")
        performSegue(withIdentifier: SEGUE_TO_FEED, sender: nil)
        
        
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return  true
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
