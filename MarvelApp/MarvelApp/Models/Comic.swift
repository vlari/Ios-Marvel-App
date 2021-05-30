//
//  Comic.swift
//  MarvelApp
//
//  Created by Obed Garcia on 5/29/21.
//

import Foundation

struct Comic: Codable {
    let id: Int
    let title: String
    let issueNumber: Int
    let description: String?
    let pageCount: Int
    let prices: [ComicPrice]
    let thumbnail: UIThumbnail
    let characters: ComicCharacters
}

struct ComicPrice: Codable {
    let type: String
    let price: Float
}

struct ComicCharacters: Codable {
    let available: Int
    let collectionURI: String
    let items: [ResourceLink]
}
