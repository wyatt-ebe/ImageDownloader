//
//  ImageSearchServiceModels.swift
//  ImageDownload
//
//  Created by Wyatt on 4/24/23.
//

import Foundation

struct ImageAnswer: Codable {
  let value: [ImageValue]
}

struct ImageValue: Codable {
  let contentSize: String
  let contentUrl: String
  let encodingFormat: String
  let thumbnailUrl: String
}
