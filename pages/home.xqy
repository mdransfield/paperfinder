xquery version "1.0-ml";

declare variable $user := xdmp:get-request-username();

<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>PaperFind: {$user} home</title>
  </head>
  <body>
    <h1>{$user} home</h1>
    <section id="searches">
      <h2>Active searches</h2>
    </section>
    <section id="feeds">
      <h2>Feeds</h2>
      <form name="add-feed-form" method="POST" action="/add-feed">
        <input name="feed" type="url" size="100" placeholder="Enter new feed URL ..."/>
        <button name="add" type="submit">Add feed</button>
      </form>
    </section>
  </body>
</html>
