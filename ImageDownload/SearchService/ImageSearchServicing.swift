//
//  ImageSearchServicing.swift
//  ImageDownload
//
//  Created by Wyatt on 4/24/23.
//

import Foundation

protocol ImageSearchServicing {
  func search(query: String) async throws -> [ImageSource]
}

struct ImageSource {
  let contentUrl: URL
  let thumbnailUrl: URL
  let id: UUID
  
  init?(contentUrl: String,
        thumbnailUrl: String) {
    guard let content = URL(string: contentUrl),
          let thumb = URL(string: thumbnailUrl) else { return nil }
    self.contentUrl = content
    self.thumbnailUrl = thumb
    self.id = UUID()
  }
}

extension ImageSource {
  init?(_ imageValue: ImageValue) {
    self.init(contentUrl: imageValue.contentUrl,
              thumbnailUrl: imageValue.thumbnailUrl)
  }
}

extension ImageSource: Hashable { }
