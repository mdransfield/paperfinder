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
      <section id="new-search">
        <h2>New search</h2>
        <form name="add-feed-form" method="POST" action="/add-search">
          <input name="terms" type="url" size="100" placeholder="Enter search term ..."/>
          <button name="add" type="submit">Create search</button>
        </form>
      </section>
      <section id="existing-searches">
        <h2>Existing searches</h2>
      </section>
    </section>
    <section id="admin">
      <p><a href="/all-feeds">Show all feeds</a></p>
    </section>
  </body>
</html>
