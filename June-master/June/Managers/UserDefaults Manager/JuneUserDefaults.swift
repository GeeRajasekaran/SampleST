//
//  JuneUserDefaults.swift
//  June
//
//  Created by Oksana Hanailiuk on 9/18/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

import UIKit

class JuneUserDefaults: NSObject {
    internal func synchronize() {
        UserDefaults.standard.synchronize()
    }
}
