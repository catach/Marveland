//
//  CharactersModel.swift
//  Marveland
//
//  Created by Marcelo Catach on 08/05/20.
//  Copyright © 2020 Marcelo Catach. All rights reserved.
//

struct CharacterModel {
    var charId: String?
    var name: String?
    var thumbnail: String?
}

struct CharactersModel {
    var characters: [CharacterModel] = []
    
    init(from response: GetCharactersResponse) {
        var thumb: String?
        
        for character in response.characters {
            var charIdString: String?
            
            if let path = character.thumbnail?.path,
                let type = character.thumbnail?.type {
                thumb = path + "/portrait_incredible." + type
            }
            
            if let charId = character.charId {
                charIdString = String(charId)
            }
            
            let char = CharacterModel(
                charId: charIdString,
                name: character.name,
                thumbnail: thumb
            )
            
            characters.append(char)
        }
    }
}
