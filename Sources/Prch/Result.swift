import Foundation

extension Result where Success: Response, Failure == ClientError {
  init(
    _: Success.Type,
    result: Result<ResponseComponents, ClientError>,
    decoder: ResponseDecoder
  ) {
    self = result.flatMap { response -> Result<Success, ClientError> in
      guard let httpStatus = response.statusCode, let data = response.data else {
        return .failure(ClientError.invalidResponse)
      }
      let result = Result<Success, Error> {
        try Success(statusCode: httpStatus, data: data, decoder: decoder)
      }
      switch result {
      case let .success(value):
        return .success(value)

      case let .failure(errorType as ClientError):
        return .failure(errorType)

      case let .failure(errorType as DecodingError):
        return .failure(ClientError.decodingError(errorType))

      case let .failure(errorType):
        return .failure(ClientError.unknownError(errorType))
      }
    }
  }

  var response: ClientResult<Success.SuccessType, Success.FailureType> {
    let success: Success
    switch self {
    case let .success(value):
      success = value

    case let .failure(error):
      return .failure(error)
    }
    switch success.decoded {
    case let .success(value):
      return .success(value)

    case let .failure(statusCode, failure):
      return .defaultResponse(statusCode, failure)
    }
  }
}
