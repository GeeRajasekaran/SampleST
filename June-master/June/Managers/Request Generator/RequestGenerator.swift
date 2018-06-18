//
//  RequestGenerator.swift
//  June
//
//  Created by Joshua Cleetus on 12/22/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

protocol RequestGenerator {
    func urlEndPointGenerator() -> String
    func bodyGenerator() -> [String: Any]
    func headerGenerator() -> Dictionary<String, String>?
}
