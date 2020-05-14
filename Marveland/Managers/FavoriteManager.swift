//
//  FavoriteManager.swift
//  Marveland
//
//  Created by Marcelo Catach on 13/05/20.
//  Copyright © 2020 Marcelo Catach. All rights reserved.
//

import Foundation
import RealmSwift

class FavoriteManager {
    
    func isFavorite(_ charId: Int) -> Bool {
        guard let realm = try? Realm() else { return false }
                
        let character = realm.object(ofType: CharacterModel.self, forPrimaryKey: charId)
        
        if let character = character {
            return character.favorite
        } else {
            return false
        }
    }
 
    func toggleFavorite(_ model: CharacterModel?) -> Bool {
        guard let realm = try? Realm() else { return false }
            
        guard let model = model else { return false }
                
        let character = realm.object(ofType: CharacterModel.self, forPrimaryKey: model.charId)
        
        if character == nil {
            try? realm.write {
                model.favorite = true
                realm.add(model, update: .all)
            }
            return true
        } else {
            try? realm.write {
                model.favorite = !model.favorite
            }
            return model.favorite
        }
    }
}
