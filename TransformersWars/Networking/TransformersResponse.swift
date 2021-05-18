//
//  TransformersResponse.swift
//  TransformersWars
//
//  Created by Claudio Emilio Villanueva Albornoz on 15-05-21.
//

import Foundation

// MARK: - GET Transformers list
struct TransformersList: Codable {
    let transformers: [Transformer]
}

/// <#Description#>
struct Transformer: Codable {
    let identifier: String
    var name: String
    var strength: Int
    var intelligence: Int
    var speed: Int
    var endurance: Int
    var rank: Int
    var courage: Int
    var firepower: Int
    var skill: Int
    var team: String
    var teamIcon: String
    // This field will be used later to define the cell´s background color
    var oddCell: Bool = false

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
