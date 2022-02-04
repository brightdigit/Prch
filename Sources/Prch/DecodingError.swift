import Foundation

public extension DecodingError {
  static func mismatch<MismatchType>(
    ofType type: MismatchType.Type,
    withCodingPath codingPath: [CodingKey] = [StringCodingKey(string: "")]
  ) -> DecodingError {
    DecodingError.typeMismatch(
      MismatchType.self,
      DecodingError.Context(
        codingPath: codingPath,
        debugDescription: "Decoding of \(type) failed"
      )
    )
  }
}
