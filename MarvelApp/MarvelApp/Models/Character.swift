//
//  Character.swift
//  MarvelApp
//
//  Created by Obed Garcia on 5/24/21.
//

import Foundation

struct Character: Codable {
    let id: Int
    let name: String
    let thumbnail: UIThumbnail
    let series: Appearance
    let stories: Appearance
    let events: Appearance
    let comics: CharacterComics
}

struct CharacterComics: Codable {
    let available: Int
    let collectionURI: String
    let returned: Int
    let items: [ResourceLink]
}

struct ResourceLink: Codable {
    let resourceURI: String
    let name: String
}
