//
//  ContentView.swift
//  ImageDownload
//
//  Created by Wyatt on 4/24/23.
//

import SwiftUI

struct ContentView: View {
  @ObservedObject var viewModel = ContentViewModel()
  
  var body: some View {
    VStack {
      ScrollView {
        LazyVGrid(columns: columns) {
          ForEach(viewModel.sources, id: \.self) { source in
            Image(uiImage: viewModel.getImage(source.thumbnailUrl))
              .resizable()
              .aspectRatio(1, contentMode: .fill)
              .clipped()
          }
        }
      }
      Spacer()
      TextField("", text: $viewModel.query, prompt: Text(" Search"))
        .padding(6)
        .border(.black)
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
      HStack {
        Text("Search")
          .padding(.vertical, 12)
          .padding(.horizontal, 24)
          .background(.gray)
          .cornerRadius(24)
          .onTapGesture {
            viewModel.searchTap()
          }
        Text("Reset")
          .onTapGesture {
            viewModel.resetTap()
          }
      }
    }
  }
}

let columns: [GridItem] = [
  .init(.flexible()),
  .init(.flexible()),
  .init(.flexible()),
]

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

/*
 AsyncImage(url: source.thumbnailUrl) { phase in
   switch phase {
   case .empty:
     ProgressView()
   case .failure:
     Image(systemName: "wifi.slash")
   case .success(let image):
     image
       .resizable()
       .aspectRatio(1, contentMode: .fill)
       .clipped()
   }
 }
 */
