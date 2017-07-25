//
//  Extensions.swift
//  BookCells
//
//  Created by Sasha Prokhorenko on 28.05.17.
//  Copyright © 2017 Sasha Prokhorenko. All rights reserved.
//

import Foundation
import UIKit

extension Sequence {
  public func failingFlatMap<T>(_ transform: (Self.Iterator.Element) throws -> T?) rethrows -> [T]? {
    var result: [T] = []
    for element in self {
      guard let transformed = try transform(element) else { return nil }
      result.append(transformed)
    }
    return result
  }
  
  /// Returns a sequence that repeatedly cycles through the elements of `self`.
  public func cycled() -> AnySequence<Iterator.Element> {
    return AnySequence { _ -> AnyIterator<Iterator.Element> in
      var iterator = self.makeIterator()
      return AnyIterator {
        if let next = iterator.next() {
          return next
        } else {
          iterator = self.makeIterator()
          return iterator.next()
        }
      }
    }
  }
}

public func mainQueue(_ block: @escaping () -> ()) {
  DispatchQueue.main.async(execute: block)
}

extension URL {
  public subscript(queryItem name: String) -> String? {
    get {
      guard let items = URLComponents(url: self, resolvingAgainstBaseURL: false)?.queryItems,
        let index = items.index(where: { $0.name == name }) else { return nil }
      return items[index].value
    }
    set {
      guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
        // Silently fail if we can't convert the URL to URLComponents
        return
      }
      let newItem = URLQueryItem(name: name, value: newValue)
      if let index = components.queryItems?.index(where: { $0.name == name }) {
        // Found a query item with this name
        components.queryItems?[index] = newItem
      } else if components.queryItems != nil {
        // Query item with this name not found, but queryItems array exists
        components.queryItems?.append(newItem)
      } else {
        // queryItems array doesn't exist yet
        components.queryItems = [newItem]
      }
      if let newURL = components.url {
        self = newURL
      }
    }
  }
}


