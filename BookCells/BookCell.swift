//
//  BookCell.swift
//  BookCells
//
//  Created by Sasha Prokhorenko on 27.05.17.
//  Copyright © 2017 Sasha Prokhorenko. All rights reserved.
//

import UIKit

final class BookCell: UICollectionViewCell {
  
  // MARK: - Instance Properties
  fileprivate let webservice = Webservice()
  
  // MARK: - Outlets
  @IBOutlet weak var thumbnail: UIImageView!
  @IBOutlet weak var bookTitle: UILabel!
  @IBOutlet weak var author: UILabel!
  @IBOutlet weak var narrator: UILabel!
  
  // MARK: - UIView
  override func prepareForReuse() {
    super.prepareForReuse()
    // Do something
  }
  
  func loadThumbnail(_ book: Book, done: @escaping (UIImage) -> ()) {
    DispatchQueue.main.async {
      self.webservice.load(book.thumbnail) { response in
        if let image = response.value {
          done(image)
        }
      }
    }
  }
}
