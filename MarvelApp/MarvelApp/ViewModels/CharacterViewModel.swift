//
//  CharacterViewModel.swift
//  MarvelApp
//
//  Created by Obed Garcia on 5/26/21.
//

import Foundation

struct CharacterViewModel {
    let id: Int
    let name: String
    let image: UIThumbnail
    let series: Appearance
    let stories: Appearance
    let events: Appearance
    let comics: CharacterComics
}
