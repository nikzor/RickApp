//
//  NetworkManager.swift
//  lab04hw
//
//  Created by Никита Зорин on 04.07.2023.
//

import Moya

protocol NetworkManagerProtocol {
    func fetchData(_ page: Int, completion: @escaping (Result<DataResponseModel, Error>) -> Void)
}

final class NetworkManager: NetworkManagerProtocol {
    private let provider = MoyaProvider<APITarget>()
    public var isRequesting = false
    
    func fetchData(_ page: Int, completion: @escaping (Result<DataResponseModel, Error>) -> Void) {
        request(target: .getData(page: page), completion: completion)
    }
}

private extension NetworkManager {
    func request<T: Decodable>(target: APITarget, completion: @escaping (Result<T, Error>) -> Void) {
        isRequesting = true
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let results = try decoder.decode(T.self, from: response.data)
                    completion(.success(results))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
            self.isRequesting = false
        }
    }
}
