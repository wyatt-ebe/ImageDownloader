//
//  MockSearchServicing.swift
//  ImageDownload
//
//  Created by Wyatt on 4/24/23.
//

import Foundation

struct MockSearchService: ImageSearchServicing {
  func search(query: String) async throws -> [ImageSource] {
    return test + test + test + test + test
  }
  
  var test: [ImageSource] { [
    .init(contentUrl: "https://www.wikiality.com/file/2016/11/bears1.jpg", thumbnailUrl: "https://tse1.mm.bing.net/th?id=OIP.IY-ytSR0TXF_6PvJdn2TPwHaE7&pid=Api")!,
    .init(contentUrl: "https://images.squarespace-cdn.com/content/v1/59b9ecdabebafb8293096530/1506927343134-BY6BAAVX3U55PNBKV7T4/ke17ZwdGBToddI8pDm48kKZXgL1Ji7UHmGubTzQKC6h7gQa3H78H3Y0txjaiv_0fDoOvxcdMmMKkDsyUqMSsMWxHk725yiiHCCLfrh8O1z4YTzHvnKhyp6Da-NYroOW3ZGjoBKy3azqku80C789l0k5fwC0WRNFJBIXiBeNI5fIE7KD2Yz4SstV-UBzEiPGqCQnF2MexJegjeNspfy18dQ/IMG_3984.jpg", thumbnailUrl: "https://tse1.mm.bing.net/th?id=OIP.ZwznyNtHu1QAaMSyTJcNigHaGO&pid=Api")!,
    .init(contentUrl: "http://www.annsheybani.com/wp-content/uploads/2012/12/bear.jpg", thumbnailUrl: "https://tse2.mm.bing.net/th?id=OIP.GiBLMFO4PtjUE-x-9dBxfwHaEo&pid=Api")!,
    .init(contentUrl: "https://cdn.wallpapersafari.com/52/40/exED5n.jpg", thumbnailUrl: "https://tse1.mm.bing.net/th?id=OIP.i2OwQoD_lHW4I7NvUiEIrQHaE8&pid=Api")!,
    .init(contentUrl: "https://www.expeditionsalaska.com/wp-content/uploads/2016/09/12_sep9205.jpg", thumbnailUrl: "https://tse1.mm.bing.net/th?id=OIP.bO-yisPMIrlcKvl8uH38-wHaE7&pid=Api")!
  ] }
}
