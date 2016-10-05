xquery version "1.0-ml";

declare variable $e := xdmp:get-request-field("e");

<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>Paper Finder</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Alegreya:400,400i|Alegreya+Sans"/>
    <link rel="stylesheet" href="static/pf.css" type="text/css"/>
  </head>
  <body>
    <h1>Paper Finder</h1>
    <section id="intro">
      <h3>Welcome to Paper Finder!</h3>
      <p>Paper Finder is a simple tool to help you discover new journal articles that interest you.</p>
      <p>Once logged in you can set up persistent searches for terms and we'll scour RSS feeds from academic journals and show you new papers that match your terms.</p>
    </section>
    <section id="login">
      <h3>Existing user?</h3>
      <p>Please login</p>
      <form name="login-form" method="POST" action="/login">
        { if ($e eq "5") then <p class="error">Username or password is incorrect</p> else () }
          <input name="username" type="text" size="32" placeholder="Username"/>
          <input name="password" type="password" size="32" placeholder="Password"/>
          <button name="login" type="submit">Login</button>
      </form>
    </section>
    <section id="register">
      <h3>New User?</h3>
      <p>Please register</p>
      <form name="register-form" method="POST" action="/register">
        <p>{ if ($e eq "4") then <p class="error">Username is already in use</p> else () }
           { if ($e eq "1") then <div class="error">Username must not be empty</div> else () }
           <input name="username" type="text" size="32" placeholder="Username"/></p>
        <p>{ if ($e eq "2") then <p class="error">Password must not be empty</p> else () }
	   <input name="password" type="password" size="32" placeholder="Password"/></p>
        <p>{ if ($e eq "3") then <p class="error">Password and confirmation must match</p> else () }
	   <input name="confirmation" type="password" size="32" placeholder="Confirm password"/></p>
        <p><button name="register" type="submit">Register</button></p>
      </form>
    </section>
  </body>
</html>
