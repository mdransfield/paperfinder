(: Update all feeds :)

xquery version "1.0-ml";

declare namespace h="xdmp:http";

declare variable $perms := (xdmp:permission('pf-user', 'execute'),
		 	    xdmp:permission('pf-user', 'read'),
			    xdmp:permission('pf-user', 'insert'),
			    xdmp:permission('pf-user', 'update'));

for $f in collection("feeds")
let $feed := xdmp:node-uri($f)
let $get := xdmp:http-get($feed,
	<options xmlns="xdmp:http">
	</options>)
  return if ($get[1]/h:response/h:code eq 200) then
           xdmp:document-insert($feed, $get[2], $perms, "feeds")
	 else ()
