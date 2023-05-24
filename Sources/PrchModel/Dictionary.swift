import Foundation

extension Dictionary: ContentDecodable where Key: Decodable, Value: Decodable {}

extension Dictionary: ContentEncodable where Key: Encodable, Value: Encodable {}
