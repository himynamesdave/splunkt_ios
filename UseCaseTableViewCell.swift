//
//  UseCaseTableViewCell.swift
//  Splunkt
//
//  Created by @himynamesdave on 4/6/15.
//  Copyright (c) 2015 Splunk Inc. All rights reserved.
//

import Foundation


class UseCaseTableViewCell: UITableViewCell {
    
    @IBOutlet var checkImageView:UIImageView!
    
    @IBOutlet var nameLabel:UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let bgColor = UIColor(white: 0.97, alpha: 1)
        self.backgroundColor = bgColor
        
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}