//
//  ListCell.swift
//  BookCells
//
//  Created by Sasha Prokhorenko on 28.05.17.
//  Copyright © 2017 Sasha Prokhorenko. All rights reserved.
//

import UIKit

class ListCell: UICollectionViewCell {
  
  // MARK: - Instance Properties
  fileprivate let webservice = Webservice()
  
  // MARK: - Outlets
  @IBOutlet weak var thumbnail: UIImageView!
  @IBOutlet weak var listTitle: UILabel!
  
  // MARK: - UIView
  override func prepareForReuse() {
    super.prepareForReuse()
    // Do something
  }
  
  func loadThumbnail(_ list: List, done: @escaping (UIImage) -> ()) {
    DispatchQueue.main.async {
      self.webservice.load(list.thumbnail) { response in
        if let image = response.value {
          done(image)
        }
      }
    }
  }
}
