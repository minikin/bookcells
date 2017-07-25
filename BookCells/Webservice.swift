//
//  Webservice.swift
//  BookCells
//
//  Created by Sasha Prokhorenko on 28.05.17.
//  Copyright © 2017 Sasha Prokhorenko. All rights reserved.
//

import Foundation

public enum Result<A> {
  case success(A)
  case error(Error)
}
extension Result {
  public init(_ value: A?, or error: Error) {
    if let value = value {
      self = .success(value)
    } else {
      self = .error(error)
    }
  }
  public var value: A? {
    guard case .success(let v) = self else { return nil }
    return v
  }
}
public enum WebServiceError: Error {
  case notAuthenticated
  case other
}
func logError<A>(_ result: Result<A>) {
  guard case let .error(e) = result else { return }
  assert(false, "\(e)")
}
public final class Webservice {
  public init() { }
  /// Loads a resource. The completion handler is always called on the main queue.
  public func load<A>(_ resource: Resource<A>, completion: @escaping (Result<A>) -> () = logError) {
    URLSession.shared.dataTask(with: resource.urlRequest, completionHandler: { data, response, _ in
      let result: Result<A>
      if let httpResponse = response as? HTTPURLResponse , httpResponse.statusCode == 401 {
        result = Result.error(WebServiceError.notAuthenticated)
      } else {
        let parsed = data.flatMap(resource.parse)
        result = Result(parsed, or: WebServiceError.other)
      }
      mainQueue { completion(result) }
    }) .resume()
  }
}
