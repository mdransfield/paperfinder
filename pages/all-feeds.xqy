xquery version "1.0-ml";

declare namespace u="urn:mdransfield:pf:users";
declare namespace rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#";
declare namespace rss="http://purl.org/rss/1.0/";

declare variable $max-feeds-to-show := 5;

declare variable $user := xdmp:get-request-username();

declare function local:feed-title($feed) as xs:string
{
  string($feed/rdf:RDF/rss:channel/rss:title)
};

<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>PaperFind: feeds [{$user}]</title>
  </head>
  <body>
    <h1>Feeds</h1>
    <section id="feeds">
      <h2>Add new feed</h2>
      <form name="add-feed-form" method="POST" action="/add-feed">
        <input name="feed" type="url" size="100" placeholder="Enter new feed URL ..."/>
        <button name="add" type="submit">Add feed</button>
      </form>
      <h2>Existing feeds</h2>
      <ol>
      {
        for $f in collection("feeds")
        return <li><a href="/feed/{xdmp:node-uri($f)}" title="show current state of feed">{local:feed-title($f)}</a></li>
      }
      </ol>
    </section>
  </body>
</html>
