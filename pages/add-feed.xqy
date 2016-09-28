xquery version "1.0-ml";

(: Add a new source feed for a user :)

declare namespace h="xdmp:http";
declare namespace u="urn:mdransfield:pf:users";

declare variable $username := xdmp:get-request-username();
declare variable $feed := xdmp:get-request-field("feed");
declare variable $user := doc(concat("/users/",xdmp:user($username),"/user.xml"));

declare function local:record-feed($feedurl as xs:string)
{
  if ($user) then xdmp:node-insert-child($user/u:user/u:feeds, <u:feed added="{current-dateTime()}">{$feedurl}</u:feed>)
  else xdmp:log("$user empty")
};

if ($feed eq '' or $user/u:user/u:feeds[u:feed = $feed]) then xdmp:redirect-response("/home")
else
  let $get := xdmp:http-get($feed,
	<options xmlns="xdmp:http">
	</options>)
  return if ($get[1]/h:response/h:code ne 200) then
           xdmp:redirect-response("/home?e=1")
         else let $insert := xdmp:document-insert($feed, $get[2], xdmp:default-permissions(), "feeds")
              let $record := local:record-feed($feed)
              return xdmp:redirect-response(concat("/home"))

