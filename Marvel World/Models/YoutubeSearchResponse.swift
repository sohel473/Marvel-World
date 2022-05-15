//
//  YoutubeSearchResponse.swift
//  Marvel World
//
//  Created by Abdullah Al Sohel on 5/15/22.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: IdVideoElement
}

struct IdVideoElement: Codable {
    let videoId: String
}

