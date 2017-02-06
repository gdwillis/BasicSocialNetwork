//
//  SignOutVC.swift
//  BasicSocialNetwork
//
//  Created by admin on 1/20/17.
//  Copyright © 2017 gdw. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper
import GoogleSignIn
class SignOutVC: UIViewController {

    @IBAction func onSignOut(_ sender: Any) {
        User.resetBooks()
        let keychainResult = KeychainWrapper.standard.removeObject(forKey:KEY_UID)
        print("GW: ID removed from keychian \(keychainResult)")
        GIDSignIn.sharedInstance().signOut()
        try! FIRAuth.auth()?.signOut()
        self.performSegue(withIdentifier: UNWINDSEGUE_TO_AUTH, sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
