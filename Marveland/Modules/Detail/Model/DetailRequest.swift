//
//  DetailRequest.swift
//  Marveland
//
//  Created by Marcelo Catach on 11/05/20.
//  Copyright © 2020 Marcelo Catach. All rights reserved.
//

import ObjectMapper

struct DetailRequest {
    let charId: String?
}

extension DetailRequest: ImmutableMappable {
    
    init(map: Map) throws {
        charId = try map.value("charId")
    }
    
    mutating func mapping(map: Map) {
        charId >>> map["charId"]
    }
}
