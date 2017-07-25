//
//  CellDescriptor.swift
//  BookCells
//
//  Created by Sasha Prokhorenko on 28.05.17.
//  Copyright © 2017 Sasha Prokhorenko. All rights reserved.
//

import UIKit

struct CellDescriptor {
  let cellClass: UICollectionViewCell.Type
  let reuseIdentifier: String
  let configure: (UICollectionViewCell) -> ()
  
  init<Cell: UICollectionViewCell>(reuseIdentifier: String, configure: @escaping (Cell) -> ()) {
    self.cellClass = Cell.self
    self.reuseIdentifier = reuseIdentifier
    self.configure = { cell in
      configure(cell as! Cell)
    }
  }
}
