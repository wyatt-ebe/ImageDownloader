//
//  ImageSearchService.swift
//  ImageDownload
//
//  Created by Wyatt on 4/24/23.
//

import Foundation

struct ImageSearchService: ImageSearchServicing {
  let endpoint = "https://api.bing.microsoft.com/v7.0/images/search"
  let key = "0725372eedc047a0bdbcbd7b2d6df707"
  
  func search(query: String) async throws -> [ImageSource] {
    var components = URLComponents(string: endpoint)!
    components.queryItems = [
      URLQueryItem(name: "q", value: query),
      URLQueryItem(name: "count", value: "20"),
    ]
    var request = URLRequest(url: components.url!)
    request.addValue(key, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
    let (data, _) = try await URLSession.shared.data(for: request) // parse response properly...
    let answer = try JSONDecoder().decode(ImageAnswer.self, from: data)
    return answer.value.compactMap{ ImageSource($0) }
  }
}
