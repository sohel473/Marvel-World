//
//  Character.swift
//  Marvel World
//
//  Created by Abdullah Al Sohel on 5/15/22.
//

import Foundation

struct CharacterResponse: Codable {
    let data: CharacterData
}

struct CharacterData: Codable {
    let results: [Character]
}

struct Character: Codable {
    let id: Int
    let name: String?
    let title: String?
    let description: String?
    let thumbnail: Thumbnail
    let urls: [URLElement]
}

struct Thumbnail: Codable {
    let path: String?
}

struct URLElement: Codable {
    let url: String?
}
