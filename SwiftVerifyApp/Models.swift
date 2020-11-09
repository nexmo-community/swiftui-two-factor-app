//
//  Models.swift
//  SwiftVerifyApp
//
//  Created by Abdulhakim Ajetunmobi on 09/11/2020.
//

import Foundation


struct RequestBody: Codable {
    let number: String
}

struct RequestResponse: Codable {
    let requestID: String
    
    private enum CodingKeys: String, CodingKey {
        case requestID = "request_id"
    }
}

struct CheckBody: Codable {
    let requestID: String
    let code: String
    
    private enum CodingKeys: String, CodingKey {
        case requestID = "request_id"
        case code
    }
}

struct CheckResponse: Codable {
    let status: String
}
