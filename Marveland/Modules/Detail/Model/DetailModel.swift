//
//  DetailModel.swift
//  Marveland
//
//  Created by Marcelo Catach on 11/05/20.
//  Copyright © 2020 Marcelo Catach. All rights reserved.
//

struct DetailModel {
    var charId: String?
    
    init(from response: DetailResponse) {
        var charIdString: String?
                
        if let charId = response.charId {
            charIdString = String(charId)
        }
    
        charId = charIdString
    }
}
