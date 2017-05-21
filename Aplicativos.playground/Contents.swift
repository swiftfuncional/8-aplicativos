func read(_ json: JsonObject) -> Result<User, ParseError> {
	return curry(User.init)
		<%> json.get("username")
		<*> json.get("password")
		<*> json.get("premium")
		<*> json.get("newsletter")
}

let json: String = "{" +
	"\"username\": \"alex\"," +
	"\"password\": \"functionalswift\"," +
	"\"premium\": true," +
	"\"newsletter\": false" +
"}"

let jsonObject = JsonObject(json: json)

read(jsonObject).map {
	print($0)
}