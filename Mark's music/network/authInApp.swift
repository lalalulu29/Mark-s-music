//
//  authInApp.swift
//  Mark's music
//
//  Created by Кирилл Любарских  on 11.04.2021.
//

import Foundation
import UIKit
import CryptoKit

class AuthorizationInApp {
    let urlString = "https://music.mark99.ru/api"
    func getTocken(username: String, password: String, response: @escaping (Data) -> ()) {
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        guard let httpBody = crateHttpBody(username: username, password: password) else {return}
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let urlSession = URLSession.shared
        urlSession.dataTask(with: request) { (data, responce, error) in
            guard let data = data else {return}
            response(data)
        }.resume()
    }
    
    
    private func crateHttpBody(username: String, password: String) -> Data? {
        
        guard let uuid = UIDevice.current.identifierForVendor?.uuidString else {return nil}
        guard let passwordHash = getPaswordHash(password: password) else {return nil}
        let httpBodyString: [String: Any] = [
            "command": "auth",
            "login": username,
            "phash": passwordHash.lowercased(),
            "os_type": "ios",
            "os_ver": getOSInfo(),
            "os_id": uuid,
            "token_life": 3153600
//            "token_life": 30
        ]
        print(httpBodyString)
        guard let readyHttpBody = try? JSONSerialization.data(withJSONObject: httpBodyString, options: []) else {return nil}
        
        return readyHttpBody
        
    }
    private func getPaswordHash(password: String) -> String? {
        guard let data = password.data(using: .utf8) else {return nil}
        let hash = SHA256.hash(data: data)
        return hash.hexStr
        
    }
    
    private func getOSInfo()->String {
        let os = ProcessInfo().operatingSystemVersion
        return String(os.majorVersion) + "." + String(os.minorVersion) + "." + String(os.patchVersion)
    }
}


extension Digest {
    var bytes: [UInt8] { Array(makeIterator()) }
    var data: Data { Data(bytes) }

    var hexStr: String {
        bytes.map { String(format: "%02X", $0) }.joined()
    }
}


extension AuthorizationInApp {
    func checkToken(token: String, dataWithRezult: @escaping (Data) ->()) {
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        guard let body = makeHttpBodyForCheckToken(token: token) else {return}
        request.httpBody = body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let urlSession = URLSession.shared
        urlSession.dataTask(with: request) {(data, responce, error) in
            guard let data = data else {return}
            dataWithRezult(data)
        }.resume()
        
    }
    
    private func makeHttpBodyForCheckToken(token: String) -> Data? {
        let body = [
            "command": "keep",
            "token": token
        ]
        
        guard let readyHttpBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {return nil}
        
        return readyHttpBody
    }
}
