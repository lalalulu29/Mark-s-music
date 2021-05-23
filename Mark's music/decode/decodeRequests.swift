//
//  decodeRequests.swift
//  Mark's music
//
//  Created by Кирилл Любарских  on 11.04.2021.
//

import Foundation

class DecodeRequests {
    func decodeAuth(data: Data, response: @escaping (authResponse)->()) {
        do {
            let decodedData = try JSONDecoder().decode(authResponse.self, from: data)
            response(decodedData)
        } catch {
            
        }
    }
    func decodeKeepAliveReq(data: Data, response: @escaping (tokenCheck)->()) {
        do {
            let decodedData = try JSONDecoder().decode(tokenCheck.self, from: data)
            response(decodedData)
        } catch {
            
        }
    }
    
    func decodeTracksList(data: Data, response: @escaping (getMyTracks)->()) {
        do {
            let decodedData = try JSONDecoder().decode(getMyTracks.self, from: data)
            response(decodedData)
        } catch {
            print("error with decoding")
            print(error)
        }
        
    }
}

