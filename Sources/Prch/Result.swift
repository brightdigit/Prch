import Foundation

extension Result where Success: APIResponseValue, Failure == APIClientError {
  init(
    _: Success.Type,
    result: Result<Response, APIClientError>,
    decoder: ResponseDecoder
  ) {
    self = result.flatMap { response -> APIResult<Success> in
      guard let httpStatus = response.statusCode, let data = response.data else {
        return .failure(APIClientError.invalidResponse)
      }
      let result = Result<Success, Error> {
        try Success(statusCode: httpStatus, data: data, decoder: decoder)
      }
      switch result {
      case let .success(value):
        return .success(value)

      case let .failure(errorType as APIClientError):
        return .failure(errorType)

      case let .failure(errorType as DecodingError):
        return .failure(APIClientError.decodingError(errorType))

      case let .failure(errorType):
        return .failure(APIClientError.unknownError(errorType))
      }
    }
  }
}
