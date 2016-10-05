xquery version "1.0-ml";

(: Deal with items that users click.

Log what users actually click through so we can analyse them

Need to store the items separately from their feed because the feed
will update and items will disappear.

:)

declare namespace u="urn:mdransfield:pf:users";
declare namespace rdf ="http://www.w3.org/1999/02/22-rdf-syntax-ns#";
declare namespace rss="http://purl.org/rss/1.0/";
declare namespace dc="http://purl.org/dc/elements/1.1/";

declare variable $username := xdmp:get-request-username();
declare variable $article  := xdmp:get-request-field("article");
declare variable $user     := doc(concat("/users/",xdmp:user($username),"/user.xml"));


let $item := cts:search(//rss:item, cts:and-query((
			cts:collection-query("feeds"),
			cts:element-value-query(xs:QName("rss:link"), $article)
			)))
(: This is simplistic, needs revisiting :)
let $store := xdmp:document-insert($article, $item, xdmp:default-permissions(), ("clicks", concat("user:",xdmp:user($username))))
return xdmp:redirect-response($article)
