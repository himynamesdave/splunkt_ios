//
//  DoubleExtension.swift
//  Splunkt
//
//  Created by @himynamesdave on 4/6/15.
//  Copyright (c) 2015 Splunk Inc. All rights reserved.
//

import Foundation

extension Double
{
    func toString() -> String {
        return String(format: "%.8f",self)
    }
    
    func toTwoDigitString() -> String {
        return String(format: "%.2f",self)
    }
}
