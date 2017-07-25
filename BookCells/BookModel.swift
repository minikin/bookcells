//
//  BookModel.swift
//  BookCells
//
//  Created by Sasha Prokhorenko on 28.05.17.
//  Copyright © 2017 Sasha Prokhorenko. All rights reserved.
//

import Foundation
import UIKit

public typealias JSONDictionary = [String: Any]

struct Book {
  let title: String
  let authors: [String] // Should be a model in real life app
  let narrators: [String] // Should be a model in real life app
  let thumbnailURL: URL
  init(title: String, authors: [String], narrators: [String], thumbnailURL:URL) {
    self.title = title
    self.authors = authors
    self.narrators = narrators
    self.thumbnailURL = thumbnailURL
  }
}

// MARK: - Let's assume that we have a valid JSON response
extension Book {
  init?(json: JSONDictionary) {
    guard let metadataJSON =  json["metadata"] as? JSONDictionary,
          let title = metadataJSON["title"] as? String,
          let authorsJSON = metadataJSON["authors"] as? [JSONDictionary],
          let narratorsJSON = metadataJSON["narrators"] as? [JSONDictionary],
          let coverJSON = metadataJSON["cover"] as? JSONDictionary,
          let thumbnail = coverJSON["url"] as? String,
          let thumbnailURL = URL(string: thumbnail) else {
            return nil
    }
    
    var authors: [String] = []
    for item in authorsJSON {
      for (key, value) in item {
        if key == "name" {
          authors.append(value as! String)
        }
      }
    }
    
    var narrators: [String] = []
    for item in narratorsJSON {
      for (key, value) in item {
        if key == "name" {
          narrators.append(value as! String)
        }
      }
    }
    
    self.title = title
    self.authors = authors
    self.narrators = narrators
    self.thumbnailURL = thumbnailURL
  }
}
extension Book {
  func configureCell(_ cell: BookCell){
    cell.bookTitle.text = title
    cell.author.text = authors.joined(separator: ",")
    cell.narrator.text = narrators.joined(separator: ",")
    cell.loadThumbnail(self) { image in
      cell.thumbnail.image = image
    }
  }
}
extension Book {
  var cellDescriptor: CellDescriptor {
    return CellDescriptor(reuseIdentifier: "BookCell", configure: self.configureCell)
  }
}
extension Book {
  static var all: Resource<[Book]> = try! Resource(
    url: Environment.baseURL,
    parseKey: "consumables",
    parseElement: Book.init
  )
}
extension Book {
  var thumbnail: Resource<UIImage> {
    return Resource(url: thumbnailURL, parse: { UIImage(data: $0 as Data) }, method: .get)
  }
}

