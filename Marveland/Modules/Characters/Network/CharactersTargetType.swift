//
//  CharactersTargetType.swift
//  Marveland
//
//  Created by Marcelo Catach on 08/05/20.
//  Copyright © 2020 Marcelo Catach. All rights reserved.
//

import Moya
import ObjectMapper

enum CharactersTargetType: TargetType {

    case getCharacters(GetCharactersRequest)

    var baseURL: URL {
        return URL(string: "https://gateway.marvel.com/v1/public")!
    }

    var path: String {
        switch self {
        case .getCharacters:
            return "/characters"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getCharacters:
            return .get
        }
    }

    var task: Task {
        let timestamp = "\(Date().timeIntervalSince1970)"
        let hash = (timestamp
            + Keys.Marvel.privateKey
            + Keys.Marvel.publicKey).md5
        
        switch self {
        case .getCharacters(let request):
            var params = request.toJSON()
            params["apikey"] = Keys.Marvel.publicKey
            params["ts"] = timestamp
            params["hash"] = hash
            return Task.requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }

    var sampleData: Data { return Data() }
    var headers: [String: String]? { return nil }
}
