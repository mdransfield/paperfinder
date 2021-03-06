xquery version "1.0-ml";

declare variable $username := xdmp:get-request-field("username");
declare variable $password := xdmp:get-request-field("password");
declare variable $confirmn := xdmp:get-request-field("confirmation");

if ($username eq '') then
xdmp:redirect-response("/?e=1")
else if ($password eq '') then
  xdmp:redirect-response("/?e=2")
else if ($password ne $confirmn) then
  xdmp:redirect-response("/?e=3")
else
  try {
	let $newuser := xdmp:eval('
    	        xquery version "1.0-ml";
                import module "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
		
                declare variable $username as xs:string external;
                declare variable $password as xs:string external;

	        sec:create-user($username, "pf user", $password, "pf-user", (), ())',
		(xs:QName("username"), $username, xs:QName("password"), $password),
		<options xmlns="xdmp:eval">
		  <database>{xdmp:security-database()}</database>
		</options>)
	let $login := xdmp:login($username, $password, true())
	let $record := xdmp:document-insert(concat("urn:mdransfield:pf:users#", $newuser),
		<user xmlns="urn:mdransfield:pf:users">
		  <id>{$newuser}</id>
		</user>,
		(xdmp:permission('pf-user', 'execute'),
		 xdmp:permission('pf-user', 'read'),
		 xdmp:permission('pf-user', 'insert'),
		 xdmp:permission('pf-user', 'update')),
		"users")
	return xdmp:redirect-response("/home")
  }
  catch ($exception) {
	$exception
(:	xdmp:redirect-response("/?e=4"):)
  }