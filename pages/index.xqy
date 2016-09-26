xquery version "1.0-ml";

<html xmlns="http://www.w3.org/1999/xhtml">
<title>PaperFinder</title>
<body>
<h1>PaperFinder</h1>
<form name="login-form" method="POST" action="/login">
<fieldset>
<legend>Login</legend>
<div><label for="username">Username: </label><input name="username" type="text" size="32" placeholder="Enter username"/>
<label for="password">Password: </label><input name="password" type="password" size="32" placeholder="Enter password"/></div>
<button name="login" type="submit">Login</button>
</fieldset>
</form>
<form name="register-form" method="POST" action="/register">
<fieldset>
<legend>Register</legend>
<p><label for="username">Username: </label><input name="username" type="text" size="32" placeholder="Enter username"/></p>
<p><label for="password">Password: </label><input name="password" type="password" size="32" placeholder="Enter password"/></p>
<p><label for="confirmation">Confirm Password: </label><input name="confirmation" type="password" size="32" placeholder="Confirm password"/></p>
<p><button name="register" type="submit">Register</button></p>
</fieldset>
</form>
</body>
</html>
