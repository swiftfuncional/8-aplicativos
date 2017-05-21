import Foundation

public struct JsonObject {
	let dictionary: [String: AnyObject]?

	public init(json: String) {
		dictionary = json.data(using: .utf8)
			.flatMap { try? JSONSerialization.jsonObject(with: $0) }
			.flatMap { $0 as? [String: AnyObject] }
	}

	public func get<S>(_ key: String) -> Result<S, ParseError> {
		guard let value = dictionary?[key] else {
			return .Failure(ParseError.NotFound(key))
		}

		return (value as? S).flatMap { .Success($0) } ??
			.Failure(ParseError.NotCastable(key, S.self))
	}
}

public enum ParseError {
	case NotFound(String)
	case NotCastable(String, Any.Type)
}
