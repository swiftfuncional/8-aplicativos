class AddUserUseCase {

	let db = UserDatabase()

	func add(name: String, password: String, premium: Bool, newsletter: Bool) -> Result<User, UserError> {

		let userResult = Result.pure(newsletter)
			.apply(Result.pure(premium)
				.apply(CommonValidator.Password(password)
					.apply(CommonValidator.Name(name)
						.map(curry(User.init)))))

		let userValidator = UserValidator.Premium || UserValidator.Newsletter
		
		let userValidation = userResult.flatMap(userValidator)

		userValidation.map(db.create)
	}
}

let useCase = AddUserUseCase()

useCase.add(name: "Alex", password: "functional", premium: true, newsletter: false).map {
	print("SUCCESS: User created - \($0)")
}
