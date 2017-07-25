//
//  Resource.swift
//  BookCells
//
//  Created by Sasha Prokhorenko on 28.05.17.
//  Copyright © 2017 Sasha Prokhorenko. All rights reserved.
//

import Foundation

public enum HttpMethod<A> {
  case get
  case post(payload: A?)
  
  public var method: String {
    switch self {
    case .get: return "GET"
    case .post: return "POST"
    }
  }
  public func map<B>(f: (A) throws -> B) rethrows -> HttpMethod<B> {
    switch self {
    case .get: return .get
    case .post(let payload):
      guard let payload = payload else { return .post(payload: nil) }
      return .post(payload: try f(payload))
    }
  }
}
public struct Resource<A> {
  public var url: URL
  public var parse: (Data) -> A?
  public var method: HttpMethod<Data> = .get
}
extension Resource {
  public var urlRequest: URLRequest {
    var request = URLRequest(url: url)
    request.httpMethod = method.method
    if case .post(let payload) = method {
      request.httpBody = payload
    }
    return request
  }
}
extension Resource {
  public init(url: URL, parseJSON: @escaping (Any) -> A?) {
    self.url = url
    self.method = .get
    self.parse = { data in
      let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
      return json.flatMap(parseJSON)
    }
  }
  public init(url: URL, method: HttpMethod<Any>, parseJSON: @escaping (Any) -> A?) throws {
    self.url = url
    self.method = try method.map { jsonObject in
      try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions())
    }
    self.parse = { data in
      let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
      return json.flatMap(parseJSON)
    }
  }
}
extension Resource where A: RangeReplaceableCollection {
  public init(url: URL, parseKey: String, method: HttpMethod<Any> = .get, parseElement: @escaping (JSONDictionary) -> A.Iterator.Element?) throws {
    self = try Resource(url: url, method: method, parseJSON: { json in
      guard let jsonDicts = json as? JSONDictionary,
            let consumablesJSON =  jsonDicts[parseKey] as? [JSONDictionary],
            let result = consumablesJSON.failingFlatMap(parseElement) else { return nil }
      return A(result)
    })
  }
}
extension Resource {
  public init(url: URL, method: HttpMethod<Any> = .get, parseElement: @escaping (JSONDictionary) -> Any) throws {
    self = try Resource(url: url, method: method, parseJSON: { json in
      guard let jsonDicts = json as? JSONDictionary else { return nil }
      let result = parseElement(jsonDicts)
      return result as? A
    })
  }
}
