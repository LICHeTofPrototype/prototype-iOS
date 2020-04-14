//
//  Parse.swift
//  lichet
//
//  Created by 神崎知波 on 2020/04/12.
//  Copyright © 2020 Kanzaki. All rights reserved.
//

import Foundation
import Combine

func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, Errors> {
  let decoder = JSONDecoder()
  decoder.dateDecodingStrategy = .secondsSince1970//date型のパース方法
  return Just(data)
    .decode(type: T.self, decoder: decoder)
    .mapError { error in
      .parsing(description: error.localizedDescription)
    }
    .eraseToAnyPublisher()
}
