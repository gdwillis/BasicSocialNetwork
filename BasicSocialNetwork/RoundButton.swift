//
//  RoundButton.swift
//  BasicSocialNetwork
//
//  Created by admin on 10/21/16.
//  Copyright © 2016 gdw. All rights reserved.
//

import UIKit

class RoundButton: UIButton {
    //frame sizes are not calcualated yet in awakFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        imageView?.contentMode = .scaleAspectFit
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width / 2
    }
}
