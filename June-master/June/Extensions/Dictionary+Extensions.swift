//
//  Dictionary+Extensions.swift
//  June
//
//  Created by Joshua Cleetus on 8/17/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

extension Dictionary {
    
    /// Build string representation of HTTP parameter dictionary of keys and objects
    ///
    /// This percent escapes in compliance with RFC 3986
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// :returns: String representation in the form of key1=value1&key2=value2 where the keys and values are percent escaped
    
    func stringFromHttpParameters(encode: Bool = true) -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey: String
            let percentEscapedValue: String
            
            percentEscapedKey = encode ? (key as! String).addingPercentEncodingForURLQueryValue()! : (key as! String)
            percentEscapedValue = encode ? (value as! String).addingPercentEncodingForURLQueryValue()!: (value as! String)
            
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        
        return parameterArray.joined(separator: "&")
    }
    
    mutating func update(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}
