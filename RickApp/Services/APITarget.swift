//
//  ApiTarget.swift
//  lab04hw
//
//  Created by Никита Зорин on 04.07.2023.
//

import Moya

enum APITarget {
    case getData
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
        return .requestPlain
    }

    var headers: [String: String]? {
        return ["Content-type":"application/json", "Cache-Control":"no-cache"]
    }
}
