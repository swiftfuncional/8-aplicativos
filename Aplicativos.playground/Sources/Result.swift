public enum Result<S, E> {
	case Success(_: S)
	case Failure(_: E)

	public func map<T>(_ transform: (S) -> T) -> Result<T, E> {
		return self.flatMap { .Success(transform($0))  }
	}

	public func flatMap<T>(_ transform: (S) -> Result<T, E>) -> Result<T, E> {
		switch self {
		case let .Failure(reason):
			return .Failure(reason)
		case let .Success(value):
			return transform(value)
		}
	}

	public static func pure<A>(a: A) -> Result<A, E> {
		return .Success(a)
	}
}

public func curry<A, B, C, D, E>(_ fn: @escaping (A, B, C, D) -> E) -> (A) -> (B) -> (C) -> (D) -> E {
	return { a in { b in { c in { d in fn(a, b, c, d) } } } }
}
