xquery version "1.0-ml";

(: Fetch a feed :)

declare variable $feedurl external;

let $get := xdmp:http-get($feedurl)
when $get[1] eq 200