xquery version "1.0-ml";

(: Add a new source feed for a user :)

import module namespace sem = "http://marklogic.com/semantics" at "/MarkLogic/semantics.xqy";

declare namespace s="urn:mdransfield:pf:search";

declare variable $usrname := xdmp:get-request-username();
declare variable $terms   := xdmp:get-request-field("terms");
declare variable $usruri  := concat("urn:mdransfield:pf:users#", xdmp:user($usrname));
declare variable $user    := doc($usruri);
declare variable $perms   := (
	xdmp:permission('pf-user', 'execute'),
	xdmp:permission('pf-user', 'read'),
	xdmp:permission('pf-user', 'insert'),
	xdmp:permission('pf-user', 'update'));

if ($terms eq '') then xdmp:redirect-response("/home")
else
  let $srchid  := xdmp:hash64($terms)
  let $search  := <s:search last-run="{xs:dateTime('1900-01-01T00:00:00Z')}">
                    <s:id>{$srchid}</s:id>
                    <s:terms>{$terms}</s:terms>
                  </s:search>
  
  let $srchuri := concat("urn:mdransfield:pf:searches#", $srchid)
  let $addsrch := xdmp:document-insert($srchuri, $search, $perms, "searches")
  let $triples := sem:triple(
	sem:iri($usruri),
	sem:iri("urn:mdransfield:pf:created"),
	sem:iri($srchuri),
	sem:iri("urn:mdransfield:pf"))
  let $rdf     := sem:rdf-insert($triples)
  return xdmp:redirect-response("/home")
