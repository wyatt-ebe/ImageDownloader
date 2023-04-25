//
//  ContentViewModel.swift
//  ImageDownload
//
//  Created by Wyatt on 4/24/23.
//

import SwiftUI

class ContentViewModel: ObservableObject {
  let imageSearchService: ImageSearchServicing
  @Published var sources: [ImageSource] = []
  @Published var imageDict: [URL:UIImage] = [:]
  var query: String = ""
  private var previousQuery: String?
  
  init(imageSearchService: ImageSearchServicing = MockSearchService()) {
    self.imageSearchService = imageSearchService
  }
  
  func searchTap() {
    if query == previousQuery { return }
    previousQuery = query
    performSearch()
  }
  
  func resetTap() {
    query = ""
    previousQuery = nil
    sources = []
    imageDict = [:]
  }
  
  func getImage(_ url: URL) -> UIImage {
    imageDict[url] ?? UIImage()
  }
}

extension ContentViewModel {
  func performSearch() {
    Task {
      let imageSources = try await imageSearchService.search(query: query)
      await MainActor.run {
        self.sources = imageSources
      }
      
      let thumbnailUrls = imageSources.map{ $0.thumbnailUrl }
      
//      let dict = try await DownloadModel().download(thumbnailUrls)
//      await MainActor.run {
//        self.imageDict = dict
//      }
      
//      DownloadModel().downloadGCD(thumbnailUrls) { dict in
//        DispatchQueue.main.async {
//          self.imageDict = dict
//        }
//      }
      
//      let dict = DownloadModel().downloadSem(thumbnailUrls)
//      DispatchQueue.main.async {
//        self.imageDict = dict
//      }
      
//      DownloadModel().downloadOperationQueue(thumbnailUrls) { dict in
//        DispatchQueue.main.async {
//          self.imageDict = dict
//        }
//      }
      
      let model = DownloadModel()
      model.downloadCombine(thumbnailUrls) { dict in
        DispatchQueue.main.async {
          self.imageDict = dict
        }
      }
    }
  }
}
