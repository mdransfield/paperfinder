xquery version "1.0-ml";

declare variable $username := xdmp:get-request-field("username");
declare variable $password := xdmp:get-request-field("password");

if (xdmp:login($username, $password)) then xdmp:redirect-response("/home")
else xdmp:redirect-response("/?e=5")