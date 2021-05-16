//
//  TransformersResponse.swift
//  TransformersWars
//
//  Created by Claudio Emilio Villanueva Albornoz on 15-05-21.
//

import Foundation

// MARK: - GET Transformers list
struct TransformersList {
    let transformers: [Transformer]
}

struct Transformer {
    let identifier: String
    let name: String
    let strength: Int
    let intelligence: Int
    let speed: Int
    let endurance: Int
    let rank: Int
    let courage: Int
    let firepower: Int
    let skill: Int
    let team: String
    let teamIcon: String

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name = "name"
        case strength = "strength"
        case intelligence = "intelligence"
        case speed = "speed"
        case endurance = "endurance"
        case rank = "rank"
        case courage = "courage"
        case firepower = "firepower"
        case skill = "skill"
        case team = "team"
        case teamIcon = "team_icon"
    }
}
