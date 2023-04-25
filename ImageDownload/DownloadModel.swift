//
//  DownloadModel.swift
//  ImageDownload
//
//  Created by Wyatt on 4/24/23.
//

import Foundation
import SwiftUI
import Combine

class DownloadModel {
  // thread safe usage of TaskGroup to download conncurently. Exact concurrency not defined
  func download(_ urls: [URL]) async throws -> [URL:UIImage] {
    var dict = [URL:UIImage]()
    try await withThrowingTaskGroup(of: (URL, URL).self) { taskGroup in
      for url in urls {
        taskGroup.addTask {
          let (local, _) = try await URLSession.shared.download(from: url)
          return (url, local)
        }
      }
      for try await result in taskGroup {
        dict[result.0] = UIImage(contentsOfFile: result.1.path)
      }
    }
    return dict
  }
  
  
  // Thread safe call to downloadTask in bulk
  func downloadGCD(_ urls: [URL], completion: @escaping ([URL:UIImage]) -> Void) {
    let queue = DispatchQueue(label: "download", qos: .background, attributes: .concurrent)
    var pending = urls.count
    var result = [URL:UIImage]()
    
    for url in urls {
      queue.async {
        let request = URLRequest(url: url)
        URLSession.shared.downloadTask(with: request) { [url] (local, response, error) in
          queue.sync(flags: .barrier) {
            pending -= 1
            if let local = local,
               let image = UIImage(contentsOfFile: local.path) {
              result[url] = image
            }
            if pending == 0 {
              completion(result)
            }
          }
        }.resume()
      }
    }
  }
  
  /// Use semaphores to allow specific number of downloads to be active at a single time
  func downloadSem(_ urls: [URL],
                   active: Int = 5) -> [URL:UIImage] {
    let sem = DispatchSemaphore(value: 0)
    for _ in 0..<active { sem.signal() }
    
    var result = [URL:UIImage]()
    for url in urls {
      sem.wait()
      DispatchQueue.global().async {
        let request = URLRequest(url: url)
        URLSession.shared.downloadTask(with: request) { [url] (local, response, error) in
          if let local = local,
             let image = UIImage(contentsOfFile: local.path) {
            result[url] = image
          }
          sem.signal()
        }.resume()
      }
    }
    for _ in 0..<active { sem.wait() }
    return result
  }
  
  func downloadOperationQueue(_ urls: [URL],
                              active: Int = 5,
                              completion: @escaping ([URL:UIImage]) -> Void) {
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = active

    var result = [URL:UIImage]()
    for url in urls {
      queue.addOperation {
        let sem = DispatchSemaphore(value: 0)
        let request = URLRequest(url: url)
        URLSession.shared.downloadTask(with: request) { [url] (local, response, error) in
          if let local = local,
             let image = UIImage(contentsOfFile: local.path) {
            result[url] = image
          }
          sem.signal()
        }.resume()
        sem.wait()
      }
    }
    queue.addBarrierBlock {
      completion(result)
    }
  }
  
  func downloadCombine(_ urls: [URL],
                       active: Int = 5,
                       closure: @escaping ([URL:UIImage]) -> Void) {
    var result = [URL:UIImage]()
    var cancellables = Set<AnyCancellable>()
    urls
      .publisher
      .flatMap(maxPublishers: .max(active)) { URLSession.shared.dataTaskPublisher(for: $0) }
      .sink(
        receiveCompletion: { completion in
          closure(result)
          cancellables = []
        }, receiveValue: { data, response in
          guard let url = response.url,
                let image = UIImage(data: data) else { return }
          result[url] = image
        })
      .store(in: &cancellables)
  }
}
