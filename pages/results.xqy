xquery version "1.0-ml";

declare namespace u="urn:mdransfield:pf:users";
declare namespace s   = "urn:mdransfield:pf:search";
declare namespace rss="http://purl.org/rss/1.0/";
declare namespace dc="http://purl.org/dc/elements/1.1/";

declare variable $username := xdmp:get-request-username();
declare variable $searchid := xdmp:get-request-field("search");
declare variable $srchuri  := concat("urn:mdransfield:pf:searches#", $searchid);
declare variable $search   := doc($srchuri)/s:search;

<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>Paper Finder: search results [{$search/string(s:terms)}]</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Alegreya:400,400i|Alegreya+Sans"/>
    <link rel="stylesheet" href="/static/pf.css" type="text/css"/>
  </head>
  <body>
    <h1><a href="/">Paper Finder</a></h1>
    <section id="results">
      <h2>Search results for "{$search/string(s:terms)}"</h2>
      {
      let $results := cts:search(//rss:item, cts:and-query((
				cts:collection-query("feeds"),
				cts:word-query($search/string(s:terms)),
				cts:element-range-query(xs:QName("dc:date"), ">", xs:dateTime($search/@last-run)))))
      (: Update the last-run timestamp so as not repeatedly show the same results :)
      let $update := xdmp:node-replace($search/@last-run, attribute last-run { current-dateTime() })
      return if ($results) then
		<ol>
		{
		  for $i in $results
			return 
			  <li class="result">
			     <div class="article-title"><a href="/click/{xdmp:url-encode($i/rss:link)}" target="_blank">{$i/string(dc:title)}</a></div>
			     <div class="journal-title">{string($i/../rss:channel/rss:title)}</div>
			     <div class="authors">{string($i/dc:creator)}</div>
			     <div class="date">{string($i/dc:date)}</div>
			  </li>
		}
		</ol>
	     else
		<p>No new results.</p>
    }
    </section>
  </body>
</html>
