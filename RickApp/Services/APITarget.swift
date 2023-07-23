//
//  ApiTarget.swift
//  lab04hw
//
//  Created by Никита Зорин on 04.07.2023.
//

import Moya

enum APITarget {
    case getData(page: Int = 1)
}

extension APITarget: TargetType {
    var baseURL: URL {
        return URL(string: "https://rickandmortyapi.com/api")!
    }

    var path: String {
        switch self {
        case .getData:
            return "/character"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch(self) {
        case let .getData(page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.queryString)
        }
    }
    
    
    var headers: [String: String]? {
        return ["Content-type":"application/json", "Cache-Control":"no-cache"]
    }
}
