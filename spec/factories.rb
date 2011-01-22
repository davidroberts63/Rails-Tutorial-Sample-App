# By using the symbole ':user' we get the factory girl to simulate the User model.
Factory.define :user do |user|
	user.name "David Roberts"
	user.email "dr@example.com"
	user.password "foobar"
	user.password_confirmation "foobar"
end