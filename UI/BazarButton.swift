//
//  BazarButton.swift
//  Splunkt
//
//  Created by @himynamesdave on 4/6/15.
//  Copyright (c) 2015 Splunk Inc. All rights reserved.
//

import UIKit

class BazarButton: UIButton {

    
    //[UIColor colorWithRed:0.255 green:0.506 blue:0.180 alpha:1.000]
    let bazarRed = UIColor(red: 0.255, green: 0.506, blue: 0.180, alpha: 1)
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    override func awakeFromNib() {
        self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0)
        self.imageEdgeInsets = UIEdgeInsetsMake(0, -24, 0, 0)
        self.backgroundColor = bazarRed
        
    }

}
