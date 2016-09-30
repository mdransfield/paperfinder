xquery version "1.0-ml";

(: Add a new source feed for a user :)

declare namespace u="urn:mdransfield:pf:users";

declare variable $username := xdmp:get-request-username();
declare variable $terms := xdmp:get-request-field("terms");
declare variable $user  := doc(concat("/users/",xdmp:user($username),"/user.xml"));

if ($terms eq '') then xdmp:redirect-response("/home")
else
let $search := <u:search id="{xdmp:hash64($terms)}" last-run="{xs:dateTime('1900-01-01T00:00:00Z')}">
                 <u:terms>{$terms}</u:terms>
               </u:search>
  let $addsrch := xdmp:node-insert-child($user/u:user/u:searches, $search)
  return xdmp:redirect-response("/home")
