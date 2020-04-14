//
//  PnnClient.swift
//  lichet
//
//  Created by 神崎知波 on 2020/04/12.
//  Copyright © 2020 Kanzaki. All rights reserved.
//

import Foundation
import Combine

protocol PnnClientProtocol {
    func getPnn(userId: Int) -> AnyPublisher<PnnResponse, Errors>
}

class PnnClient {
    private let session: URLSession
    init(session: URLSession = .shared){
        self.session = session
    }
}

private extension PnnClient {
    struct getPnnAPI {
        static let scheme = "http"
        static let host = "192.168.2.103"//随時変更
        static let port = 8000
        static let path = "/v1/api/get_data/pnn/"
    }
    
    func makeGetPnnComponents() -> URLComponents{
        var components = URLComponents()
        components.scheme = getPnnAPI.scheme
        components.host = getPnnAPI.host
        components.port = getPnnAPI.port
        components.path = getPnnAPI.path
        
//        components.queryItems = []//パラメータないので
        return components
    }
}

extension PnnClient: PnnClientProtocol{
    func getPnn(userId: Int) -> AnyPublisher<PnnResponse, Errors> {
        return pnn(userId: userId, components: makeGetPnnComponents())
    }
    private func pnn<T>(userId: Int, components: URLComponents) -> AnyPublisher<T, Errors> where T: Decodable{
        guard let url = components.url else {
            let error = Errors.network(description: "Couldn't create URL")
            return Fail(error: error).eraseToAnyPublisher()
        }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("utf-8", forHTTPHeaderField: "Accept-Charset")
        do {
            let body = try JSONEncoder().encode(PnnRequest.init(userId: userId))
            request.httpBody = body
        } catch {
            print("encodeError")
        }
        return session.dataTaskPublisher(for: request)
            .mapError{ errors in
                .network(description: errors.localizedDescription)
            }
            .flatMap(maxPublishers: .max(1)){ pair in
                decode(pair.data)
            }
            .eraseToAnyPublisher()
    }
}
