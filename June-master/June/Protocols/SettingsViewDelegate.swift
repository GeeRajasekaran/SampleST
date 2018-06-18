//
//  SettingsViewDelegate.swift
//  June
//
//  Created by Joshua Cleetus on 8/10/17.
//  Copyright © 2017 Joshua Cleetus. All rights reserved.
//

protocol SettingsViewDelegate:class {
    func fullNameEdited(_ editedFullName : String?)
    func profilePictureEdited(_ editedProfileImage : UIImage?)
}
