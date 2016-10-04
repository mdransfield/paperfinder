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
    <title>Paper Finder: feeds</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Alegreya:400,400i|Alegreya+Sans"/>
    <link rel="stylesheet" href="static/pf.css" type="text/css"/>
  </head>
  <body>
    <h1><a href="/">Paper Finder</a></h1>
    <h2>Feeds</h2>
    <section id="add">
      <h3>Add new feed</h3>
      <form name="add-feed-form" method="POST" action="/add-feed">
        <input name="feed" type="url" size="100" placeholder="Enter new feed URL ..."/>
        <button name="add" type="submit">Add feed</button>
      </form>
    </section>
    <section id="existing">
      <h3>Existing feeds</h3>
      <ol>
      {
        for $f in collection("feeds")
        return <li><a href="/feed/{xdmp:node-uri($f)}" title="show current state of feed">{local:feed-title($f)}</a></li>
      }
      </ol>
    </section>
    <section id="update">
      <p><a href="/update-feeds">Update all feeds</a></p>
    </section>
  </body>
</html>
