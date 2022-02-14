import Foundation

public extension DecodingError {
  static func mismatch<MismatchType>(
    ofType type: MismatchType.Type,
    withCodingPath codingPath: [CodingKey]? = nil
  ) -> DecodingError {
    let codingPath = codingPath ?? [StringCodingKey(stringValue: "")]
    return DecodingError.typeMismatch(
      MismatchType.self,
      DecodingError.Context(
        codingPath: codingPath,
        debugDescription: "Decoding of \(type) failed"
      )
    )
  }
}
