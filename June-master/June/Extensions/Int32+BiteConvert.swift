//
//  Int32+BiteConvert.swift
//  June
//
//  Created by Oksana Hanailiuk on 11/14/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import Foundation

extension Int32 {
    func convertToMB() -> String {
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useMB]
        bcf.countStyle = .file
        let string = bcf.string(fromByteCount: Int64(self))
        return string
    }
}
