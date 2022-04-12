import Foundation

public struct NetworkClient {
  public var send: (URLRequest) async throws -> (Data, URLResponse)

  public init(send: @escaping (URLRequest) async throws -> (Data, URLResponse)) {
    self.send = send
  }
}

extension NetworkClient {
  static let live: Self = {
    .init(
      send: { request in
        try await URLSession.shared
          .data(
            for: request,
            delegate: nil
          )
      }
    )
  }()
}
