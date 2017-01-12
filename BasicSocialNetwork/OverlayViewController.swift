//
//  OverlayViewController.swift
//  MovieSelector
//
//  Created by admin on 1/6/17.
//  Copyright © 2017 gdw. All rights reserved.
//

import UIKit

class OverlayViewController: UIViewController {

    @IBOutlet weak var TitleLabel: UILabel!

    @IBOutlet weak var descriptionTextView: UITextView!
    
    //var book:Book?
    
    func configureView() {
    
      //  if let book = self.book {
        //self.TitleLabel.text = book.title
      //  self.descriptionTextView.text = book.description
      //  }
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.view.bounds.size = CGSize(width: UIScreen.main.bounds.size.width - 20, height: 200)
        
        self.view.layer.cornerRadius = 5
        
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

   
    @IBAction func close(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
