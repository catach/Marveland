//
//  DetailResponse.swift
//  Marveland
//
//  Created by Marcelo Catach on 11/05/20.
//  Copyright © 2020 Marcelo Catach. All rights reserved.
//

import ObjectMapper

// MARK: - GetCharacterResponse
struct DetailResponse {
    var charId: Int?
}

extension DetailResponse: ImmutableMappable {
    init(map: Map) throws {
        charId = try map.value("charId")
    }
}
