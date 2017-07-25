//
//  ListModel.swift
//  BookCells
//
//  Created by Sasha Prokhorenko on 28.05.17.
//  Copyright © 2017 Sasha Prokhorenko. All rights reserved.
//

import UIKit

struct List {
  let title: String
  let thumbnailURL: URL
  init(title: String, thumbnailURL: URL) {
    self.title = title
    self.thumbnailURL = thumbnailURL
  }
}

// MARK: - Let's assume that we have a valid JSON response
extension List {
  init?(json: JSONDictionary) {
    guard let mainJSON = json["metadata"] as? JSONDictionary,
          let title = mainJSON["title"] as? String,
          let coverJSON = mainJSON["cover"] as? JSONDictionary,
          let thumbnail = coverJSON["url"] as? String,
          let thumbnailURL = URL(string: thumbnail) else {
        return nil
    }
    self.title = title
    self.thumbnailURL = thumbnailURL
  }
}
extension List {
  func configureCell(_ cell: ListCell){
    cell.listTitle.text = title
    cell.loadThumbnail(self) { image in
      cell.thumbnail.image = image
    }
  }
}
extension List {
  var cellDescriptor: CellDescriptor {
    return CellDescriptor(reuseIdentifier: "ListCell", configure: self.configureCell)
  }
}
extension List {
  static var item: Resource<List> = try! Resource(
    url: Environment.baseURL,
    parseElement: List.init
  )
}

extension List {
  var thumbnail: Resource<UIImage> {
    return Resource(url: thumbnailURL, parse: { UIImage(data: $0 as Data) }, method: .get)
  }
}
