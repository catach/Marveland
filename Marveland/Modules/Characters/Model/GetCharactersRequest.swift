//
//  GetCharactersRequest.swift
//  Marveland
//
//  Created by Marcelo Catach on 08/05/20.
//  Copyright © 2020 Marcelo Catach. All rights reserved.
//

import ObjectMapper

enum OrderBy: String {
    case name
}

struct GetCharactersRequest {
    let orderBy: OrderBy?
    let limit: Int?
    let offset: Int?
}

extension GetCharactersRequest: ImmutableMappable {
    
    init(map: Map) throws {
        orderBy = try map.value("orderBy")
        limit = try map.value("limit")
        offset = try map.value("offset")
    }
    
    mutating func mapping(map: Map) {
        orderBy >>> map["orderBy"]
        limit >>> map["limit"]
        offset >>> map["offset"]
    }
}
