public typealias Validator<T, E> = (T) -> Result<T, E>

public func &&<T, E>(
	_ firstValidator: @escaping Validator<T, E>,
	_ secondValidator: @escaping Validator<T, E>) -> Validator<T, E> {

	return { firstValidator($0).flatMap(secondValidator) }
}

public func ||<T, E>(
	_ firstValidator: @escaping Validator<T, E>,
	_ secondValidator: @escaping Validator<T, E>) -> Validator<T, E> {

	return { t in
		let result = firstValidator(t)

		switch result {
		case .Failure:
			return secondValidator(t)
		case .Success:
			return result
		}
	}
}

public func validate<T, E>(_ reason: E, _ condition: @escaping (T) -> Bool) -> Validator<T, E> {
	return { condition($0) ? .Success($0) : .Failure(reason) }
}

public func allOf<T, E>(_ validators: [Validator<T, E>]) -> Validator<T, E> {
	let identity: Validator<T, E> = { .Success($0) }
	return validators.reduce(identity) { $0 && $1 }
}
