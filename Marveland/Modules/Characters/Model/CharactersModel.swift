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
    var imagePortrait: String?
    var imageLandscape: String?
    var description: String
    var comicsAppearances: Int
    var comicsName: [String]
}

struct CharactersModel {
    var characters: [CharacterModel] = []
    
    init(from response: GetCharactersResponse) {
        var imagePortrait: String?
        var imageLandscape: String?
        
        for character in response.characters {
            var charIdString: String?
            
            if let path = character.thumbnail?.path,
                let type = character.thumbnail?.type {
                imagePortrait = path + "/portrait_incredible." + type
                imageLandscape = path + "." + type
            }
            
            if let charId = character.charId {
                charIdString = String(charId)
            }
            
            let char = CharacterModel(
                charId: charIdString,
                name: character.name,
                imagePortrait: imagePortrait,
                imageLandscape: imageLandscape,
                description: character.description,
                comicsAppearances: character.comicsAppearances,
                comicsName: character.comics.compactMap { $0.name }
            )
            
            characters.append(char)
        }
    }
}
