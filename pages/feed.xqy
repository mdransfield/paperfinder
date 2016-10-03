xquery version "1.0-ml";

declare namespace u="urn:mdransfield:pf:users";
declare namespace rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#";
declare namespace rss="http://purl.org/rss/1.0/";

declare variable $feed := xdmp:get-request-field("feed");

doc($feed)
