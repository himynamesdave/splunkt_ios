//
//  ArrayExtension.swift
//  Splunkt
//
//  Created by @himynamesdave on 4/6/15.
//  Copyright (c) 2015 Splunk Inc. All rights reserved.
//

import Foundation

extension Array {
    
    private var indexesInterval: HalfOpenInterval<Int> { return HalfOpenInterval<Int>(0, self.count) }
    
    /**
    Joins the array elements with a separator.
    
    :param: separator
    :return: Joined object if self is not empty and its elements are instances of C, nil otherwise
    */
    func implode <C: ExtensibleCollectionType> (separator: C) -> C? {
        if Element.self is C.Type {
            return Swift.join(separator, unsafeBitCast(self, [C].self))
        }
        
        return nil
    }
}