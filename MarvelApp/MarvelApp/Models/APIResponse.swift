//
//  APIResponse.swift
//  MarvelApp
//
//  Created by Obed Garcia on 5/24/21.
//

import Foundation

struct APIResponse<APIResponseModel: Codable>: Codable {
    let code: Int
    let data: APIResponseDetail<APIResponseModel>
}

struct APIResponseDetail<APIResponseModel: Codable>: Codable {
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: [APIResponseModel]
}
