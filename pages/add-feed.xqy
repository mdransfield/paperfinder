xquery version "1.0-ml";

(: Add a new source feed for a user :)

declare namespace h="xdmp:http";
declare namespace u="urn:mdransfield:pf:users";

declare variable $user := xdmp:get-request-username();
declare variable $feed := xdmp:get-request-field("feed");

declare function local:record-feed($username as xs:string, $feedurl as xs:string)
{
  let $user := doc(concat("/users/",xdmp:user($username),"/user.xml"))/u:user
  return xdmp:node-insert-child($user/u:feeds, <u:feed>{$feed}</u:feed>)

};

if ($feed eq '') then xdmp:redirect-response("/home")
else
  let $get := xdmp:http-get($feed,
	<options xmlns="xdmp:http">
	</options>)
  return if ($get[1]/h:response/h:code ne 200) then
           xdmp:redirect-response("/home?e=1")
         else let $insert := xdmp:document-insert($feed, $get[2], xdmp:default-permissions(), "feeds")
              let $record := local:record-feed($user,$feed)
              return xdmp:redirect-response("/home")

