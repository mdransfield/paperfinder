xquery version "1.0-ml";

declare namespace u="urn:mdransfield:pf:users";
declare namespace rss="http://purl.org/rss/1.0/";
declare namespace dc="http://purl.org/dc/elements/1.1/";

declare variable $username := xdmp:get-request-username();
declare variable $search := xdmp:get-request-field("search");
declare variable $user := doc(concat("/users/",xdmp:user($username),"/user.xml"));

declare function local:search-terms($search) as xs:string
{
  $user/u:user/u:searches/u:search[@id eq $search]/string(u:terms)
};

declare function local:search-last-run($search) as xs:dateTime
{
  $user/u:user/u:searches/u:search[@id eq $search]/@last-run
};

<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>PaperFind: search results [{local:search-terms($search)}]</title>
  </head>
  <body>
    <h1>Search results for "{local:search-terms($search)}"</h1>
    {
      let $results := cts:search(//rss:item, cts:and-query((
				cts:word-query(local:search-terms($search)),
				cts:element-range-query(xs:QName("dc:date"), ">", local:search-last-run($search)))))
      where $results
      return 
	<ol>
	{
	  for $i in $results
		return 
		  <li><div class="article-title"><a href="{$i/rss:link}">{$i/string(dc:title)}</a></div>
		     <div class="journal-title">{string($i/../rss:channel/rss:title)}</div>
		     <div class="authors">{string($i/dc:creator)}</div>
		     <div class="date">{string($i/dc:date)}</div>
		  </li>
	}
	</ol>
    }
  </body>
</html>
