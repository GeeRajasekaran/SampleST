//
//  NSURL+Extensions.swift
//  June
//
//  Created by Joshua Cleetus on 8/9/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

/// An extension on `NSURL` to support Data URIs.
extension NSURL {
    
    /// `true` if the receiver is a Data URI. See https://en.wikipedia.org/wiki/Data_URI_scheme.
    var dataURI: Bool {
        return scheme == "data"
    }
    
    /// Extracts the base 64 data string from the receiver if it is a Data URI. Otherwise or if there is no data, returns `nil`.
    var base64EncodedDataString: String? {
        guard dataURI else { return nil }
        
        let newString : NSString = NSString.init(string: absoluteString!)
        let components = newString.components(separatedBy: ";base64,")
        return components.last
    }
    
    /// Extracts the data from the receiver if it is a Data URI. Otherwise or if there is no data, returns `nil`.
    var base64DecodedData: NSData? {
        guard let string = base64EncodedDataString else { return nil }
        
        // Ignore whitespace because "Data URIs encoded in Base64 may contain whitespace for human readability."
        
        return NSData(base64Encoded: string, options: .ignoreUnknownCharacters)
    }
}
