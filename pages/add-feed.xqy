xquery version "1.0-ml";

(: Add a new source feed for a user :)

declare namespace h="xdmp:http";
declare namespace u="urn:mdransfield:pf:users";

declare variable $user := xdmp:get-request-username();
declare variable $feed := xdmp:get-request-field("feed");

declare function local:record-feed($uid as xs:unsignedLong, $feedurl as xs:string)
{
  let $u := concat("/users/",$uid,"/user.xml")
  let $dbg := xdmp:log(concat("$u == '",$u,"'"))
  let $user := doc($u)
  return if ($user) then xdmp:node-insert-child($user/u:user/u:feeds, <u:feed>{$feedurl}</u:feed>)
         else xdmp:log("$user empty")
};

if ($feed eq '') then xdmp:redirect-response("/home")
else
  let $get := xdmp:http-get($feed,
	<options xmlns="xdmp:http">
	</options>)
  return if ($get[1]/h:response/h:code ne 200) then
           xdmp:redirect-response("/home?e=1")
         else let $insert := xdmp:document-insert($feed, $get[2], xdmp:default-permissions(), "feeds")
              let $record := local:record-feed(xdmp:user($user),$feed)
              return xdmp:redirect-response(concat("/home"))

