import Foundation

struct URLGenericSessionResponse: GenericSessionResponse {
  internal init(httpURLResponse: HTTPURLResponse, data: Data) {
    self.httpURLResponse = httpURLResponse
    self.data = data
  }

  internal init(_ tuple: (Data, URLResponse)) throws {
    guard let response = tuple.1 as? HTTPURLResponse else {
      throw RequestError.invalidResponse(tuple.1)
    }
    self.init(httpURLResponse: response, data: tuple.0)
  }

  let httpURLResponse: HTTPURLResponse
  let data: Data

  var statusCode: Int {
    httpURLResponse.statusCode
  }
}
