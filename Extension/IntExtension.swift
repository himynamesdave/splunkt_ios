//
//  IntExtension.swift
//  Splunkt
//
//  Created by @himynamesdave on 4/6/15.
//  Copyright (c) 2015 Splunk Inc. All rights reserved.
//

import Foundation


extension Int
{
    func toString() -> String
    {
      var myString =   String(format:"%d",self)
        //var myString = String(self)
        return myString
    }
}