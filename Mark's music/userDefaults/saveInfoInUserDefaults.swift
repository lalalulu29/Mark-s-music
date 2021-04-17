//
//  File.swift
//  Mark's music
//
//  Created by Кирилл Любарских  on 11.04.2021.
//

import Foundation

class saveUserDefaults {
    func saveInUserDefaults(token: String, userName: String) {
        let defaults = UserDefaults.standard
        defaults.setValue(userName, forKey: "userName")
        defaults.setValue(token, forKey: "token")
        
    }
}
