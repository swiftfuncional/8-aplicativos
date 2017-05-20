public struct User {
	public let name: String
	public let password: String
	public let premium: Bool
	public let newsletter: Bool

	public init(name: String, password: String, premium: Bool, newsletter: Bool) {
		self.name = name
		self.password = password
		self.premium = premium
		self.newsletter = newsletter
	}
}

public enum UserError {
	case UsernameOutOfBounds
	case PasswordTooShort
	case MustBePremium
	case MustBeSubscribeToNewsletter
}

public class UserValidator {

	public static var all = [(Premium || Newsletter)]

	public class var Premium: Validator<User, UserError> {
		return validate(.MustBePremium) {
			$0.premium
		}
	}

	public class var Newsletter: Validator<User, UserError> {
		return validate(.MustBeSubscribeToNewsletter) {
			$0.newsletter
		}
	}
}

public class CommonValidator {

	public class var Name: Validator<String, UserError> {
		return validate(.UsernameOutOfBounds) {
			!$0.isEmpty && $0.characters.count <= 15
		}
	}

	public class var Password: Validator<String, UserError> {
		return validate(.PasswordTooShort) {
			$0.characters.count >= 10
		}
	}
}
