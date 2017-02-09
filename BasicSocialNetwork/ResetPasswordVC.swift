//
//  ResetPasswordVC.swift
//  BasicSocialNetwork
//
//  Created by admin on 2/9/17.
//  Copyright © 2017 gdw. All rights reserved.
//

import UIKit
import Firebase

class ResetPasswordVC: UIViewController, UITextFieldDelegate  {

    @IBOutlet weak var errorLabel: UILabel!
    @IBAction func onResetPassword(_ sender: Any) {
        emailValidater.isHidden = true
        guard let email = emailTextField.text, !email.isEmpty else {
            emailValidater.isHidden = false
            return
        }
        
        FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: { error in
            
            if error != nil{
                let error = error! as NSError
                let errCode = FIRAuthErrorCode(rawValue: error.code )
                self.errorLabel.isHidden = false
                if errCode == .errorCodeUserNotFound {
                    self.errorLabel.text = "Error: User not found"
                }
                else if errCode == .errorCodeInvalidEmail {
                    self.errorLabel.text = "Error: This is not a valid email"
                }
                    
                else {
                    self.errorLabel.text = "Error: Something went wrong please try again later"                }
            }

            else {
                let alert = UIAlertController(title: "Success", message: "A password reset request has been sent to \(email)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Done", style: .default, handler: {action in
                    if action.style == .default {
                        print("alert callback")
                        self.dismiss(animated: true, completion: nil)}
                }))
                
                self.present(alert, animated: true, completion: nil)
            }
            
            })

    }
    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailValidater: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self 
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
