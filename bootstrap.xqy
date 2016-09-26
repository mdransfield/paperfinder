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
	"C:\users\mdransfi\github\paperfinder\pages\",
	9000,
	"file-system",
	admin:database-get-id($config, "pf-db"))
return admin:save-configuration($config)


;


(: Assign url rewrite :)

xquery version "1.0-ml";

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

let $config := admin:get-configuration()
let $groupid := admin:group-get-id($config, "Default")
let $config := admin:appserver-set-url-rewriter($config, admin:appserver-get-id($config, $groupid, "pf-http"), "url-rewrites.xml")
return admin:save-configuration($config)
