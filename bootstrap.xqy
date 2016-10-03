(: Bootstrap application configuration :)

(: Set up forest and database, etc. :)

xquery version "1.0-ml";

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

let $config := admin:get-configuration()
let $forest := if (not(admin:forest-exists($config, "pf-forest"))) then
                 admin:forest-create($config, "pf-forest", xdmp:host(), ())
               else
                 $config
let $db     := if (not(admin:database-exists($config, "pf-db"))) then
                 admin:database-create($config, "pf-db", xdmp:database("Security"), xdmp:database("Schemas"))
               else
                 $forest
return admin:save-configuration($db)


;


(: Attach forest to database :)

xquery version "1.0-ml";

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

let $config := admin:get-configuration()
let $db     := xdmp:database("pf-db")
let $forest := xdmp:forest("pf-forest")
let $attach := if (admin:database-get-attached-forests($config, $db) != $forest) then
                 admin:database-attach-forest($config, $db, $forest)
               else
                 $config
return admin:save-configuration($attach)


;


(: Create fragment roots for feeds :)

xquery version "1.0-ml";

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

declare namespace db = "http://marklogic.com/xdmp/database";

(: this is crazy but there's no easy way of telling if a fragment root already exists in a db :)
declare function local:fragment-root-exists(
	$config as element(configuration),
	$databaseId as xs:unsignedLong,
	$fragmentRoot as element(db:fragment-root)) as xs:boolean
{
  let $exrts  := admin:database-get-fragment-roots($config, $databaseId)
  let $exnss  := for $f in $exrts return string($f/db:namespace-uri)
  let $exlns  := for $f in $exrts return string($f/db:localname)
  return ($exnss = $fragmentRoot/db:namespace-uri and $exlns = $fragmentRoot/db:localname)
};

let $config := admin:get-configuration()
let $fragrt := admin:database-fragment-root("http://purl.org/rss/1.0/", "item")
let $db     := xdmp:database("pf-db")
let $frgadd := if (not(local:fragment-root-exists($config, $db, $fragrt))) then
                 admin:database-add-fragment-root($config, $db, $fragrt)
               else 
                 $config
return admin:save-configuration($frgadd)


;


(: Add range indexes :)

xquery version "1.0-ml";

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

declare namespace db = "http://marklogic.com/xdmp/database";

declare function local:element-range-index-exists(
	$config as element(configuration),
	$databaseId as xs:unsignedLong,
	$namespaceuri as xs:string,
	$localname as xs:string) as xs:boolean
{
  if (for $ri in admin:database-get-range-element-indexes($config, $databaseId)
    where $ri/db:range-element-index/db:namespace-uri eq $namespaceuri and $ri/db:range-element-index/db:localname eq $localname
    return $ri) then true()
  else
    false()
};

let $config := admin:get-configuration()
let $dbid   := xdmp:database("pf-db")
let $nsuri  := "http://purl.org/dc/elements/1.1/"
let $lname  := "date"
let $rngidx := if (not(local:element-range-index-exists($config, $dbid, $nsuri, $lname))) then
                 admin:database-add-range-element-index($config, $dbid, admin:database-range-element-index("dateTime", $nsuri, $lname, "", false()))
               else $config
return admin:save-configuration($rngidx)


;


(: Create app server :)

xquery version "1.0-ml";

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

let $config  := admin:get-configuration()
let $groupId := admin:group-get-id($config, "Default")
let $appserv := if (not(admin:appserver-exists($config, $groupId, "pf-http"))) then
                  admin:http-server-create(
	            $config, 
	            $groupId, 
	            "pf-http",
	            (if (xdmp:platform() eq "winnt") then
		       "C:\users\mdransfi\github\paperfinder\"
		     else
		       "/home/mdransfield/stuff/paperfinder/"
	            ),
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
let $groupid := admin:group-get-id($config, "Default")
let $appsrvid := admin:appserver-get-id($config, $groupid, "pf-http")
let $urlrwrt := if (admin:appserver-get-url-rewriter($config, $appsrvid) ne "page/url-rewrites.xml") then
                  admin:appserver-set-url-rewriter($config, $appsrvid, "pages/url-rewrites.xml")
                else
                  $config
let $authnt  := admin:appserver-set-authentication($config, $appsrvid, "application-level")
let $dfltusr := admin:appserver-set-default-user($config, $appsrvid, xdmp:eval('
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

let $config  := admin:get-configuration()
let $groupid := admin:group-get-id($config, "Default")
let $task    := admin:group-daily-scheduled-task(
		  "/update-feeds.xqy",
		  (if (xdmp:platform() eq "winnt") then
		     "C:\users\mdransfi\github\paperfinder\Modules\scheduled"
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
let $schedule := admin:group-add-scheduled-task($config, $groupid, $task)
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
