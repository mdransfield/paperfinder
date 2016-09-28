xquery version "1.0-ml";

declare namespace u="urn:mdransfield:pf:users";
declare namespace rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#";
declare namespace rss="http://purl.org/rss/1.0/";

declare variable $max-feeds-to-show := 5;

declare variable $user := xdmp:get-request-username();

declare function local:feed-title($feed as element(u:feed)) as xs:string
{
  string(doc(string($feed))/rdf:RDF/rss:channel/rss:title)
};

<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>PaperFind: home [{$user}]</title>
  </head>
  <body>
    <h1>{$user} home</h1>
    <section id="searches">
      <h2>Active searches</h2>
    </section>
    <section id="admin">
      <p><a href="/all-feeds">Show all feeds</a></p>
    </section>
  </body>
</html>
