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

	public func apply<T>(_ resultST: Result<(S) -> T, E>) -> Result<T, E> {
		return self.flatMap { s in
			resultST.map { ab in
				ab(s)
			}
		}
	}

	public static func pure(_ a: S) -> Result<S, E> {
		return .Success(a)
	}
}

public func curry<A, B, C, D, E>(_ fn: @escaping (A, B, C, D) -> E) -> (A) -> (B) -> (C) -> (D) -> E {
	return { a in { b in { c in { d in fn(a, b, c, d) } } } }
}

infix operator <*>: AdditionPrecedence
infix operator <%>: AdditionPrecedence

public func <%><A, B, E>(_ transform: @escaping (A) -> B, resultA: Result<A, E>) -> Result<B, E> {
	return resultA.map(transform)
}

public func <*><A, B, E>(_ curriedResult: Result<(A) -> B, E>, resultA: Result<A, E>) -> Result<B, E> {
	return resultA.apply(curriedResult)
}

public func >>=<A, B, E>(_ resultA: Result<A, E>, transform: (A) -> Result<B, E>) -> Result<B, E> {
	return resultA.flatMap(transform)
}
