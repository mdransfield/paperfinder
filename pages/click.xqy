xquery version "1.0-ml";

(: Deal with items that users click.

Log what users actually click through so we can analyse them

Need to store the items separately from their feed because the feed
will update and items will disappear.

:)

import module namespace sem = "http://marklogic.com/semantics" at "/MarkLogic/semantics.xqy";

declare namespace u="urn:mdransfield:pf:users";
declare namespace rdf ="http://www.w3.org/1999/02/22-rdf-syntax-ns#";
declare namespace rss="http://purl.org/rss/1.0/";
declare namespace dc="http://purl.org/dc/elements/1.1/";

declare variable $username := xdmp:get-request-username();
declare variable $useruri  := concat("urn:mdransfield:pf:users#", xdmp:user($username));
declare variable $user     := doc($useruri);
declare variable $article  := xdmp:get-request-field("article");
declare variable $perms   := (
	xdmp:permission('pf-user', 'execute'),
	xdmp:permission('pf-user', 'read'),
	xdmp:permission('pf-user', 'insert'),
	xdmp:permission('pf-user', 'update'));

let $item := cts:search(//rss:item, cts:and-query((
			cts:collection-query("feeds"),
			cts:element-value-query(xs:QName("rss:link"), $article)
			)))
let $triples := sem:triple(
	sem:iri($useruri),
	sem:iri("urn:mdransfield:pf:clicked"),
	sem:iri($article),
	sem:iri("urn:mdransfield:pf"))
let $rdf     := sem:rdf-insert($triples)
return xdmp:redirect-response($article)
