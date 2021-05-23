//
//  getMyTracks.swift
//  Mark's music
//
//  Created by Кирилл Любарских  on 18.04.2021.
//

import Foundation

struct getMyTracks: Decodable {
    let command: String
    let status: String
    let hash: String
    let tracks: [tracks]

}
struct tracks: Decodable {
    let name: String
    let bitrate: Int
    let tracktime: Int
    let size: Int
    let date_add: Int
    let hash: String
    let text: String?
    let picture_link: String?
}
