//
//  CharactersModel.swift
//  Marveland
//
//  Created by Marcelo Catach on 08/05/20.
//  Copyright © 2020 Marcelo Catach. All rights reserved.
//

import RealmSwift

class CharacterModel: Object {
    @objc dynamic var charId = 0
    @objc dynamic var name: String?
    @objc dynamic var imagePortrait: String?
    @objc dynamic var imageLandscape: String?
    @objc dynamic var bio = ""
    @objc dynamic var comicsAppearances = 0
    @objc dynamic var favorite = false
    var comicsName = List<String>()
    
    override static func primaryKey() -> String? {
        return "charId"
    }
}

struct CharactersModel {
    var characters: [CharacterModel] = []
    
    init(from response: GetCharactersResponse) {
        var imagePortrait: String?
        var imageLandscape: String?
        
        for character in response.characters {
            if let path = character.thumbnail?.path,
                let type = character.thumbnail?.type {
                imagePortrait = path + "/portrait_incredible." + type
                imageLandscape = path + "." + type
            }
            
            let char = CharacterModel()
            char.charId = character.charId ?? 0
            char.name = character.name
            char.imagePortrait = imagePortrait
            char.imageLandscape = imageLandscape
            char.bio = character.bio
            char.comicsAppearances = character.comicsAppearances
            _ = character.comics.compactMap {
                if let name = $0.name {
                    char.comicsName.append(name)
                }
            }
            
            characters.append(char)
        }
    }
}
