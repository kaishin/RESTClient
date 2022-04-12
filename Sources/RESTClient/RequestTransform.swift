import Foundation

public typealias RequestTransform = (Request) throws -> (Request)

// MARK: - Property Transforms
public var identity: RequestTransform = { $0 }

public func requestHeader(
  key: String,
  value: String
) -> RequestTransform {
  { request in
    var newRequest = request
    newRequest.headers[key] = value
    return newRequest
  }
}

public func requestMethod(
  _ method: HTTPMethod
) -> RequestTransform {
  { request in
    var newRequest = request
    newRequest.method = method
    return newRequest
  }
}

public func requestBody<T>(
  _ content: T,
  encoder: JSONEncoder = .init()
) -> RequestTransform where T: Encodable {
  { request in
    guard request.method != .get else { return request }
    var newRequest = request
    newRequest.body = try encoder.encode(content)
    return newRequest
  }
}

public func requestQueries(
  _ content: [String: String]
) -> RequestTransform {
  { request in
    var newRequest = request
    newRequest.queryItems = content.reduce([], { items, keyValue in
      let item = URLQueryItem(name: keyValue.0, value: keyValue.1)
      var newItems = items
      newItems.append(item)
      return newItems
    })
    return newRequest
  }
}

public func requestCachePolicy(
  _ cachePolicy: URLRequest.CachePolicy
) -> RequestTransform {
  { request in
    var newRequest = request
    newRequest.cachePolicy = cachePolicy
    return newRequest
  }
}

public func requestTimeoutInterval(
  _ interval: TimeInterval
) -> RequestTransform {
  { request in
    var newRequest = request
    newRequest.timeoutInterval = interval
    return newRequest
  }
}

// MARK: - Common Transforms
public var getRequest: RequestTransform = requestMethod(.get)
public var jsonContentRequest: RequestTransform = requestHeader(
  key: "Content-Type",
  value: "application/json; charset=utf-8"
)

public var postRequest: RequestTransform = pipe(requestMethod(.post), jsonContentRequest)
public var putRequest: RequestTransform = pipe(requestMethod(.put), jsonContentRequest)
public var patchRequest: RequestTransform = pipe(requestMethod(.patch), jsonContentRequest)
public var deleteRequest: RequestTransform = pipe(requestMethod(.delete), jsonContentRequest)

public func post<T>(
  body: T,
  encoder: JSONEncoder = .init()
) -> RequestTransform where T: Encodable {
  pipe(
    postRequest,
    requestBody(body)
  )
}

public func put<T>(
  body: T,
  encoder: JSONEncoder = .init()
) -> RequestTransform where T: Encodable {
  pipe(
    putRequest,
    requestBody(body)
  )
}

public func patch<T>(
  body: T,
  encoder: JSONEncoder = .init()
) -> RequestTransform where T: Encodable {
  pipe(
    patchRequest,
    requestBody(body)
  )
}

public func delete<T>(
  body: T,
  encoder: JSONEncoder = .init()
) -> RequestTransform where T: Encodable {
  pipe(
    deleteRequest,
    requestBody(body)
  )
}
