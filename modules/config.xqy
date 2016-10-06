xquery version "1.0-ml";

(: Central place for config options :)

module namespace config = "urn:mdransfield:pf:config";

declare variable $config:modules-location :=
    if (xdmp:platform() eq "winnt") then
      "C:\users\mdransfi\github\paperfinder\"
    else
      "/home/mdransfield/stuff/paperfinder/";

declare variable $config:scheduled-task-location :=
   concat($config:modules-location, "scheduled");