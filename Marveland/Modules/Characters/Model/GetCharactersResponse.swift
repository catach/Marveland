//
//  GetCharactersResponse.swift
//  Marveland
//
//  Created by Marcelo Catach on 08/05/20.
//  Copyright © 2020 Marcelo Catach. All rights reserved.
//

import ObjectMapper

// MARK: - Comic
struct Comic {
    var resourceURI: String?
    var name: String?
}

extension Comic: ImmutableMappable {
    init(map: Map) throws {
        resourceURI = try map.value("resourceURI")
        name = try map.value("name")
    }
}

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
    var bio: String
    var comicsAppearances: Int
    var comics: [Comic]
}

extension CharacterResponse: ImmutableMappable {
    init(map: Map) throws {
        charId = try map.value("id")
        name = try map.value("name")
        thumbnail = try map.value("thumbnail")
        bio = try map.value("description")
        comicsAppearances = try map.value("comics.available")
        comics = try map.value("comics.items")
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
