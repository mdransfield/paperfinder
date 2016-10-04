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
    <section id="login">
      <h3>Login</h3>
      <form name="login-form" method="POST" action="/login">
        { if ($e eq "5") then <p class="error">Username or password is incorrect</p> else () }
          <input name="username" type="text" size="32" placeholder="Username"/>
          <input name="password" type="password" size="32" placeholder="Password"/>
          <button name="login" type="submit">Login</button>
      </form>
    </section>
    <section id="register">
      <h3>Register</h3>
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
