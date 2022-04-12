import Foundation

public struct RESTClient {
  public var token: String?
  public var host: String
  public var network: NetworkClient
  public var defaultDecoder: JSONDecoder

  public init(
    token: String? = nil,
    host: String,
    network: NetworkClient,
    defaultDecoder: JSONDecoder
  ) {
    self.token = token
    self.host = host
    self.network = network
    self.defaultDecoder = defaultDecoder
  }
}


enum APIClientError: Error {
  case malformedRequestURL
  case missingHostURL
}

extension RESTClient {
  public func send(
    _ request: Request,
    _ middleware: @escaping RequestTransform = identity
  ) async throws -> (Data, URLResponse) {
    let urlRequest = try urlRequest(from: middleware(request))
    return try await network.send(urlRequest)
  }

  public func send<T>(
    _ request: Request,
    _ middleware: @escaping RequestTransform = identity,
    with decoder: JSONDecoder? = nil
  ) async throws -> T where T: Decodable {
    let (data, _) = try await send(request, middleware)

    let requestDecoder = decoder ?? defaultDecoder
    let value = try requestDecoder.decode(T.self, from: data)

    return value
  }

  private func urlRequest(from request: Request) throws -> URLRequest {
    var urlRequest = URLRequest(
      url: try requestURL(for: request),
      cachePolicy: request.cachePolicy,
      timeoutInterval: request.timeoutInterval
    )

    urlRequest.httpMethod = request.method.rawValue
    urlRequest.httpBody = request.body

    request.headers.forEach {
      urlRequest.addValue(
        $0.value,
        forHTTPHeaderField: $0.key
      )
    }

    return urlRequest
  }

  private func requestURL(for request: Request) throws -> URL {
    guard var requestURL = URL(string: host) else {
      throw APIClientError.missingHostURL
    }

    request.path.fragments.forEach {
      requestURL.appendPathComponent($0.description)
    }

    if request.queryItems.isEmpty {
      return requestURL
    }

    // Query Items
    guard var components = URLComponents(
      url: requestURL,
      resolvingAgainstBaseURL: true
    ) else {
      throw APIClientError.malformedRequestURL
    }

    components.queryItems = request.queryItems

    guard let urlWithQueries = components.url else {
      throw APIClientError.malformedRequestURL
    }

    return urlWithQueries
  }
}
