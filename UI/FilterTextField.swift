//
//  FilterTextField.swift
//  Splunkt
//
//  Created by @himynamesdave on 4/6/15.
//  Copyright (c) 2015 Splunk Inc. All rights reserved.
//

import UIKit

class FilterTextField: MHTextField {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        
        self.layer.cornerRadius = 15
        self.backgroundColor = UIColor.darkGrayColor()
        self.tintColor = UIColor.darkGrayColor()
        self.textColor = UIColor.whiteColor()
    }

}
