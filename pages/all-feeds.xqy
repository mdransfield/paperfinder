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
    <title>PaperFind: feeds [{$user}]</title>
  </head>
  <body>
    <h1>{$user} feeds</h1>
    <section id="feeds">
    {
      let $u := doc(concat("/users/",xdmp:user($user),"/user.xml"))	
      return
	<ul>
	{
	  for $f in (for $i in $u/u:user/u:feeds/u:feed order by $i/@added descending return $i)
	  return <li><a href="/feed/{string($f)}">{local:feed-title($f)}</a></li>
	}
	</ul>
    }
    </section>
  </body>
</html>
