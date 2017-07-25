//
//  RecentItem.swift
//  BookCells
//
//  Created by Sasha Prokhorenko on 28.05.17.
//  Copyright © 2017 Sasha Prokhorenko. All rights reserved.
//

import UIKit

enum RecentItem {
  case list(List)
  case book(Book)
}

extension RecentItem {
  var cellDescriptor: CellDescriptor {
    switch self {
    case .list(let list):
      return CellDescriptor(reuseIdentifier: "ListCell", configure: list.configureCell)
    case .book(let book):
      return CellDescriptor(reuseIdentifier: "BookCell", configure: book.configureCell)
    }
  }
}
