import Foundation

public struct Request {
  public var method: HTTPMethod
  public var path: URIPath
  public var queryItems: [URLQueryItem]
  public var headers: [String: String]
  public var cachePolicy: URLRequest.CachePolicy
  public var timeoutInterval: TimeInterval
  public var body: Data?
}

extension Request {
  public init(
    method: HTTPMethod = .get,
    path: URIPath = .init(),
    headers: [String: String] = [:],
    queryItems: [URLQueryItem] = [],
    cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
    timeoutInterval: TimeInterval = 60.0
  ) {
    self.method = method
    self.path = path
    self.headers = headers
    self.queryItems = queryItems
    self.cachePolicy = cachePolicy
    self.timeoutInterval = timeoutInterval
  }
}
