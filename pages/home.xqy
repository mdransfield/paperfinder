xquery version "1.0-ml";

declare namespace u   ="urn:mdransfield:pf:users";
declare namespace rdf ="http://www.w3.org/1999/02/22-rdf-syntax-ns#";
declare namespace rss ="http://purl.org/rss/1.0/";
declare namespace dc  ="http://purl.org/dc/elements/1.1/";

declare variable $max-feeds-to-show := 5;

declare variable $username := xdmp:get-request-username();
declare variable $user     := doc(concat("/users/",xdmp:user($username),"/user.xml"));

<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>Paper Finder: home [{$username}]</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Alegreya:400,400i|Alegreya+Sans"/>
    <link rel="stylesheet" href="static/pf.css" type="text/css"/>
  </head>
  <body>
    <h1><a href="/">Paper Finder</a></h1>
    <h2>{$username} home</h2>
    <section id="searches">
      <section id="new-search">
        <h3>New search</h3>
        <form name="add-feed-form" method="POST" action="/add-search">
          <input name="terms" type="search" size="100" placeholder="Enter search term ..."/>
          <button name="add" type="submit">Create search</button>
        </form>
      </section>
      <section id="existing-searches">
        <h3>Existing searches</h3>
        {
	  if ($user/u:user/u:searches/u:search) then
	    <ol>
	    {
	      for $s in $user/u:user/u:searches/u:search
	      let $n := xdmp:estimate(cts:search(//rss:item, cts:and-query((
				cts:word-query($s/string(u:terms)),
				cts:element-range-query(xs:QName("dc:date"), ">", xs:dateTime($s/@last-run))
			))))
	      return <li>
		       <a href="/results/{$s/@id}">{$s/u:terms}</a>
		       {
			 if ($n > 0) then
			   <span class="new-results"> [{$n} new result{if ($n > 1) then 's' else ()}]</span>
			 else ()
		       }
		     </li>
	    }
	    </ol>
	  else
	    ()
	}
      </section>
    </section>
    <section id="admin">
      <p><a href="/all-feeds">Show all feeds</a></p>
    </section>
  </body>
</html>
