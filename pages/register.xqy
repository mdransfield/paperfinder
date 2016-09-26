xquery version "1.0-ml";

declare variable $username := xdmp:get-request-field("username", "unknown");
declare variable $password := xdmp:get-request-field("password", "unknown");
declare variable $confirmation := xdmp:get-request-field("confirmation",  "unknown");

<html xmlns="http://www.w3.org/1999/xhtml">
<body>
<h1>Registration</h1>
<ul>
<li>$username == "{$username}"</li>
<li>$password == "{$password}"</li>
<li>$confirmation == "{$confirmation}"</li>
</ul>
</body>
</html>
