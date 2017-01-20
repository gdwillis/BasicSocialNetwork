//
//  ConfirmDeleteBookVC.swift
//  BasicSocialNetwork
//
//  Created by admin on 12/18/16.
//  Copyright © 2016 gdw. All rights reserved.
//

import UIKit

class ConfirmDeleteBookVC: UIViewController {
    
    var book: Book!
    var sendersVC: BookUpdateVC!
    @IBAction func OnNo(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func OnYes(_ sender: AnyObject) {
        book.removeBook()
        
      //  self.dismiss(animated: true, completion: nil)
        
       // book.updateUsersMyBooks()
        self.performSegue(withIdentifier: "unwindToMyBooks", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
