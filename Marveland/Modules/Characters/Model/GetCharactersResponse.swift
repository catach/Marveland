//
//  GetCharactersResponse.swift
//  Marveland
//
//  Created by Marcelo Catach on 08/05/20.
//  Copyright © 2020 Marcelo Catach. All rights reserved.
//

import ObjectMapper

// MARK: - CharacterThumbnail
struct CharacterThumbnail {
    var path: String?
    var type: String?
}

extension CharacterThumbnail: ImmutableMappable {
    init(map: Map) throws {
        path = try map.value("path")
        type = try map.value("extension")
    }
}

// MARK: - Character
struct CharacterResponse {
    var charId: Int?
    var name: String?
    var thumbnail: CharacterThumbnail?
    var description: String
    var comicsAppearances: Int
    var comicsNames: [String]
}

extension CharacterResponse: ImmutableMappable {
    init(map: Map) throws {
        charId = try map.value("id")
        name = try map.value("name")
        thumbnail = try map.value("thumbnail")
    }
}

// MARK: - GetCharacterResponse
struct GetCharactersResponse {
    var characters: [CharacterResponse]
}

extension GetCharactersResponse: ImmutableMappable {
    init(map: Map) throws {
        characters = try map.value("data.results")
    }
}
