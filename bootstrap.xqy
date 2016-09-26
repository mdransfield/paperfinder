(: Bootstrap application configuration :)

(: Set up forest and database, etc. :)

xquery version "1.0-ml";

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

let $config := admin:get-configuration()

(: create forest :)
let $config := admin:forest-create($config, "pf-forest", xdmp:host(), ())

(: create db :)
let $config := admin:database-create($config, "pf-db", xdmp:database("Security"), xdmp:database("Schemas"))

(: save config :)
return admin:save-configuration($config)


;


(: Attach forest to database :)

xquery version "1.0-ml";

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

let $config := admin:get-configuration()

(: attach forest to db :)
let $config := admin:database-attach-forest($config, xdmp:database("pf-db"), xdmp:forest("pf-forest"))

(: save config :)
return admin:save-configuration($config)


;


(: Create users and roles :)
(:
xquery version "1.0-ml";

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

let $config := admin:get-configuration()




;
:)

(: Create app server :)

xquery version "1.0-ml";

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

let $config := admin:get-configuration()
let $groupId := admin:group-get-id($config, "Default")
let $config := admin:http-server-create(
	$config, 
	$groupId, 
	"pf-http",
	(if (xdmp:platform() eq "winnt") then "C:\users\mdransfi\github\paperfinder\pages\" else "/home/mdransfield/stuff/paperfinder/pages/"),
	9000,
	"file-system",
	admin:database-get-id($config, "pf-db"))
return admin:save-configuration($config)


;


(:Configure app server :)

xquery version "1.0-ml";

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

let $config := admin:get-configuration()
let $groupid := admin:group-get-id($config, "Default")
let $appsrvid := admin:appserver-get-id($config, $groupid, "pf-http")
let $config := admin:appserver-set-url-rewriter($config, $appsrvid, "url-rewrites.xml")
let $config := admin:appserver-set-authentication($config, $appsrvid, "application-level")
let $config := admin:appserver-set-default-user($config, $appsrvid, xdmp:eval('
    	          xquery version "1.0-ml";
                  import module "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy"; 

	          sec:uid-for-name("admin")', (),  
		  			      <options xmlns="xdmp:eval">
					      	 <database>{xdmp:security-database()}</database>
					      </options>))
return admin:save-configuration($config)
