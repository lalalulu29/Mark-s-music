//
//  authResponse.swift
//  Mark's music
//
//  Created by Кирилл Любарских  on 11.04.2021.
//

import Foundation

struct authResponse: Decodable {
    var command: String?
    var status: String
    var errorDesc: String?
    var token: String?
}
