//
//  Errors.swift
//  lichet
//
//  Created by 神崎知波 on 2020/04/12.
//  Copyright © 2020 Kanzaki. All rights reserved.
//

import Foundation

enum Errors: Error {
  case parsing(description: String)
  case network(description: String)
}
