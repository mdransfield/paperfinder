(: Bootstrap application configuration :)

(: Set up forest and database, etc. :)

xquery version "1.0-ml";

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

let $config := admin:get-configuration()
let $forest := admin:forest-create($config, "pf-forest", xdmp:host(), ())
let $db     := admin:database-create($forest, "pf-db", xdmp:database("Security"), xdmp:database("Schemas"))
return admin:save-configuration($db)


;


(: Attach forest to database :)

xquery version "1.0-ml";

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

let $config := admin:get-configuration()
let $db     := xdmp:database("pf-db")
let $forest := xdmp:forest("pf-forest")
let $attach := admin:database-attach-forest($config, $db, $forest)
return admin:save-configuration($attach)


;


(: Create fragment roots for feeds :)

xquery version "1.0-ml";

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

declare namespace db = "http://marklogic.com/xdmp/database";

let $config := admin:get-configuration()
let $db     := xdmp:database("pf-db")
let $fragrt := admin:database-fragment-root("http://purl.org/rss/1.0/", "item")
let $frgadd := admin:database-add-fragment-root($config, $db, $fragrt)
return admin:save-configuration($frgadd)


;


(: Add range indexes :)

xquery version "1.0-ml";

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

declare namespace db = "http://marklogic.com/xdmp/database";

let $config := admin:get-configuration()
let $db     := xdmp:database("pf-db")
let $nsuri  := "http://purl.org/dc/elements/1.1/"
let $lname  := "date"
let $rngidx := admin:database-add-range-element-index($config, $db, admin:database-range-element-index("dateTime", $nsuri, $lname, "", false()))
return admin:save-configuration($rngidx)


;


(: Create app server :)

xquery version "1.0-ml";

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";
import module namespace config = "urn:mdransfield:pf:config" at "modules/config.xqy";

let $config  := admin:get-configuration()
let $group   := admin:group-get-id($config, "Default")
let $appserv := if (not(admin:appserver-exists($config, $group, "pf-http"))) then
                  admin:http-server-create(
	            $config, 
	            $group, 
	            "pf-http",
	            $config:modules-location,
	            9000,
	            "file-system",
	            xdmp:database("pf-db"))
                else
                  $config
return admin:save-configuration($appserv)


;


(: Configure app server :)

xquery version "1.0-ml";

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

let $config  := admin:get-configuration()
let $group   := admin:group-get-id($config, "Default")
let $appsrv  := admin:appserver-get-id($config, $group, "pf-http")
let $urlrwrt := admin:appserver-set-url-rewriter($config, $appsrv, "pages/url-rewrites.xml")
let $authnt  := admin:appserver-set-authentication($urlrwrt, $appsrv, "application-level")
let $dfltusr := admin:appserver-set-default-user($authnt, $appsrv, xdmp:eval('
    	          xquery version "1.0-ml";
                  import module "http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy"; 

	          sec:uid-for-name("admin")', (),
		  <options xmlns="xdmp:eval">
		    <database>{xdmp:security-database()}</database>
		  </options>))
return admin:save-configuration($dfltusr)


;


(: Create scheduled task to update feeds :)

xquery version "1.0-ml";

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";
import module namespace config = "urn:mdransfield:pf:config" at "modules/config.xqy";

let $config := admin:get-configuration()
let $group  := admin:group-get-id($config, "Default")
let $task   := admin:group-daily-scheduled-task(
	         "/update-feeds.xqy",
		 (if (xdmp:platform() eq "winnt") then
	            "C:\users\mdransfi\github\paperfinder\scheduled"
		  else
		    "/home/mdransfield/stuff/paperfinder/scheduled"
	         ),
		 1,
		 xs:time("00:00:00"),
		 xdmp:database("pf-db"),
		 0,
		 xdmp:user("admin"),
		 ()
    	     	)
let $schedule := admin:group-add-scheduled-task($config, $group, $task)
return admin:save-configuration($schedule)


;


(: Create user role; assign privileges and permissions :)

xquery version "1.0-ml";

declare function local:run-in-sec-db($code as xs:string*){
   xdmp:eval(
    $code
    , ()
    ,<options xmlns="xdmp:eval"><database>{ xdmp:security-database() }</database></options>
    )
};

try {
  local:run-in-sec-db("import module namespace sec = 'http://marklogic.com/xdmp/security' at '/Marklogic/security.xqy';
                       sec:get-role-ids('pf-user')")
}
catch ($exception) {
  local:run-in-sec-db(
     "import module namespace sec = 'http://marklogic.com/xdmp/security' at '/MarkLogic/security.xqy';
      sec:create-role('pf-user','Role given to pf users', (), (), ())")
  ,local:run-in-sec-db(
     "import module namespace sec = 'http://marklogic.com/xdmp/security' at '/MarkLogic/security.xqy';
      sec:role-set-default-permissions('pf-user',
        (
        xdmp:permission('pf-user', 'execute'),
        xdmp:permission('pf-user', 'read'),
        xdmp:permission('pf-user', 'insert'),
        xdmp:permission('pf-user', 'update')
        )
      )")
   ,local:run-in-sec-db(
     "import module namespace sec = 'http://marklogic.com/xdmp/security' at '/MarkLogic/security.xqy';
      sec:privilege-set-roles('http://marklogic.com/xdmp/privileges/xdmp-http-get','execute',('pf-user'))")
   ,local:run-in-sec-db(
     "import module namespace sec = 'http://marklogic.com/xdmp/security' at '/MarkLogic/security.xqy';
      sec:privilege-set-roles('http://marklogic.com/xdmp/privileges/any-uri','execute',('pf-user'))")
   ,local:run-in-sec-db(
     "import module namespace sec = 'http://marklogic.com/xdmp/security' at '/MarkLogic/security.xqy';
      sec:privilege-set-roles('http://marklogic.com/xdmp/privileges/any-collection','execute',('pf-user'))")
}
