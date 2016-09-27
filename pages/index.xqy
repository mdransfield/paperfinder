xquery version "1.0-ml";

declare variable $e := xdmp:get-request-field("e");

<html xmlns="http://www.w3.org/1999/xhtml">
  <title>PaperFinder</title>
  <body>
    <h1>PaperFinder</h1>
    <h2>Login</h2>
    <form name="login-form" method="POST" action="/login">
      { if ($e eq "5") then <p class="error">Username or password is incorrect</p> else () }
      <input name="username" type="text" size="32" placeholder="Username"/>
      <input name="password" type="password" size="32" placeholder="Password"/>
      <button name="login" type="submit">Login</button>
    </form>
    <h2>Register</h2>
    { if ($e eq "4") then <p class="error">Username is already in use</p> else () }
    <form name="register-form" method="POST" action="/register">
      { if ($e eq "1") then <p class="error">Username must not be empty</p> else () }
      <p><input name="username" type="text" size="32" placeholder="Username"/></p>
      { if ($e eq "2") then <p class="error">Password must not be empty</p> else () }
      <p><input name="password" type="password" size="32" placeholder="Password"/></p>
      { if ($e eq "3") then <p class="error">Password and confirmation must match</p> else () }
      <p><input name="confirmation" type="password" size="32" placeholder="Confirm password"/></p>
      <p><button name="register" type="submit">Register</button></p>
    </form>
  </body>
</html>
