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
    <section id="feeds">
      <h2>Feeds</h2>
      {
	let $u := doc(concat("/users/",xdmp:user($user),"/user.xml"))	
	where ($u/u:user/u:feeds/u:feed)
	return 
	  (<ul>
	  {
	    for $f in $u/u:user/u:feeds/u:feed[1 to $max-feeds-to-show]
	    return <li><a href="/feed/{string($f)}">{local:feed-title($f)}</a></li>
	  }
	  </ul>,
	  if (count($u/u:user/u:feeds/u:feed) > $max-feeds-to-show) then
	    <p><a href="/all-feeds">Show all feeds</a></p>
	  else ())
      }
      <form name="add-feed-form" method="POST" action="/add-feed">
        <input name="feed" type="url" size="100" placeholder="Enter new feed URL ..."/>
        <button name="add" type="submit">Add feed</button>
      </form>
    </section>
  </body>
</html>
