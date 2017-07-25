//
//  ViewController.swift
//  BookCells
//
//  Created by Sasha Prokhorenko on 27.05.17.
//  Copyright © 2017 Sasha Prokhorenko. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
  
  // MARK: - Injections
  fileprivate var booksDataSourse = ItemsDataSource(items:[RecentItem](),
                                                    cellDescriptor:{ $0.cellDescriptor })
  
  // MARK: - Outlets
  @IBOutlet weak var booksCollectionView: UICollectionView!
  
  // MARK: - Instance Properties
  fileprivate var recentItems: [RecentItem] = []
  fileprivate let webservice = Webservice()
  fileprivate var page = 1
  
  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    booksCollectionView.dataSource = booksDataSourse
    booksCollectionView.delegate = self
    webservice.load(List.item) { result in
      guard let listItem = result.value else { return }
      self.recentItems.insert(.list(listItem), at: 0)
      self.booksDataSourse.items = self.recentItems
      self.booksCollectionView.reloadData()
    }
    webservice.load(Book.all) { results in
      guard let r = results.value else { return }
      for book in r {
        self.recentItems.append(.book(book))
      }
      self.booksDataSourse.items = self.recentItems
      self.booksCollectionView.reloadData()
    }
  }
  // MARK: - Helpers
  func loadMoreBooks(_ pageId: Int) ->  Resource<[Book]> {
    let page: Resource<[Book]> = try! Resource(
      url: Environment.baseURL.appendingPathComponent("?page=\(pageId.description)"),
      parseKey: "consumables",
      parseElement: Book.init
    )
    return page
  }
}
  // MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
      if indexPath.item == 0 {
        return CGSize(width: collectionView.frame.size.width - 20, height: 150)
      } else {
        return CGSize(width: collectionView.frame.size.width - 20, height: 97)
      }
    }
}
  // MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView,
                      willDisplay cell: UICollectionViewCell,
                      forItemAt indexPath: IndexPath) {
    if indexPath.item == (booksDataSourse.items.count - 2){
      page += 1
      let initDataSourse = self.booksDataSourse.items
      webservice.load(loadMoreBooks(page)) { results in
        guard let r = results.value else { return }
        for book in r {
          self.recentItems.append(.book(book))
        }
        self.booksDataSourse.items = self.recentItems
        print("r", self.booksDataSourse.items.count)
        if self.booksDataSourse.items.count > initDataSourse.count {
          self.booksCollectionView.reloadData()
        }
      }
    }
  }
}
