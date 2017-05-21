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
