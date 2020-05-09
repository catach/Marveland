//
//  CharactersModel.swift
//  Marveland
//
//  Created by Marcelo Catach on 08/05/20.
//  Copyright © 2020 Marcelo Catach. All rights reserved.
//

struct CharacterModel: Equatable {
    var name: String?
    var thumbnail: String?
}

struct CharactersModel: Equatable {
    var characters: [CharacterModel] = []
    
    init(from response: GetCharactersResponse) {
        var thumb: String?
        
        for character in response.characters {
            if let path = character.thumbnail?.path,
                let type = character.thumbnail?.type {
                thumb = path + "/portrait_incredible." + type
            }
            
            let char = CharacterModel(
                name: character.name,
                thumbnail: thumb
            )
            
            characters.append(char)
        }
    }
}
