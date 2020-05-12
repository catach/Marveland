//
//  DetailTargetType.swift
//  Marveland
//
//  Created by Marcelo Catach on 11/05/20.
//  Copyright © 2020 Marcelo Catach. All rights reserved.
//

import Moya
import ObjectMapper

enum DetailTargetType: TargetType {

    case getDetail(DetailRequest, String)

    var baseURL: URL {
        return URL(string: "https://gateway.marvel.com/v1/public")!
    }

    var path: String {
        switch self {
        case .getDetail(_, let charId):
            return "/characters/\(charId)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getDetail:
            return .get
        }
    }

    var task: Task {
        let timestamp = "\(Date().timeIntervalSince1970)"
        let hash = (timestamp
            + Keys.Marvel.privateKey
            + Keys.Marvel.publicKey).md5
        
        switch self {
        case .getDetail(let request, _):
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
