xquery version "1.0-ml";

(: Add a new source feed for a user :)

declare namespace h="xdmp:http";

declare variable $username := xdmp:get-request-username();
declare variable $feed := xdmp:get-request-field("feed");

if ($feed eq '' or doc($feed)) then xdmp:redirect-response("/all-feeds")
else
  let $get := xdmp:http-get($feed,
	<options xmlns="xdmp:http">
	</options>)
  return if ($get[1]/h:response/h:code ne 200) then
           xdmp:redirect-response("/home?e=1")
         else let $insert := xdmp:document-insert($feed, $get[2], xdmp:default-permissions(), "feeds")
              return xdmp:redirect-response(concat("/all-feeds"))

