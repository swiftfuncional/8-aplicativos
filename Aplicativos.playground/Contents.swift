class AddUserUseCase {

	let db = UserDatabase()

	func add(name: String, password: String, premium: Bool, newsletter: Bool) -> Result<User, UserError> {

		let userResult = curry(User.init)
			<%> CommonValidator.Name(name)
			<*> CommonValidator.Password(password)
			<*> Result.pure(premium)
			<*> Result.pure(newsletter)

		let userValidator = UserValidator.Premium || UserValidator.Newsletter
		
		let userValidation = userResult.flatMap(userValidator)

		return userValidation.map(db.create)
	}
}

let useCase = AddUserUseCase()

useCase.add(name: "Alex", password: "functional", premium: true, newsletter: false).map {
	print("SUCCESS: User created - \($0)")
}
