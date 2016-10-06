# Paper Finder

Paper Finder is a single-tier Marklogic web application prototype that tries to take some of the stress out of an academic's search for new, relevant journal articles.

It allows logged in users to subscribe to journal RSS feeds and apply simple searches to the articles in the feeds.  In a production version, matching articles would be packaged as a secondary RSS feed, allowing users to browse results in any feed reader and the application would already know about lots of journal RSS feeds.  In this prototype, new results are displayed on a web page, you have to tell the application about the feeds, and it only understands RSS 1.0.  The feeds do update via a scheduled task but because it's a prototype and not guaranteed to be running when the task is scheduled, there is also a link to update feeds.

The motivation for building this application came from a short twitter exchange I had with a working chemist in 2014 that indicated that existing discovery tools were not responsive enough because of inherent delays in academic publishing workflows.

## Set up

Currently assumes all modules are on the filesystem. Edit the paths in ./modules/config.xqy to point at the location you want, then run ./bootstrap.xqy to configure everything.

## Some feeds to try

### Chemistry

- [Angewandte Chemie International Edition](http://onlinelibrary.wiley.com/rss/journal/10.1002/(ISSN)1521-3773)
- [Chemistry - A European Journal](http://onlinelibrary.wiley.com/rss/journal/10.1002/(ISSN)1521-3765)
- [European Journal of Organic Chemistry](http://onlinelibrary.wiley.com/rss/journal/10.1002/(ISSN)1099-0690)
- [European Journal of Inorganic Chemistry](http://onlinelibrary.wiley.com/rss/journal/10.1002/(ISSN)1099-0682c)
- [ChemCatChem](http://onlinelibrary.wiley.com/rss/journal/10.1002/(ISSN)1867-3899)
- [ChemPlusChem](http://onlinelibrary.wiley.com/rss/journal/10.1002/(ISSN)2192-6506)
- [Journal of Computational Chemistry](http://onlinelibrary.wiley.com/rss/journal/10.1002/(ISSN)1096-987X)

### Computer science

- [Software: Practice and Experience](http://onlinelibrary.wiley.com/rss/journal/10.1002/(ISSN)1097-024X)
- [Random Structures & Algorithms](http://onlinelibrary.wiley.com/rss/journal/10.1002/(ISSN)1098-2418)
- [Journal of Software: Evolution and Process](http://onlinelibrary.wiley.com/rss/journal/10.1002/(ISSN)2047-7481)
- [Computational Intelligence](http://onlinelibrary.wiley.com/rss/journal/10.1111/(ISSN)1467-8640)
- [International Journal of Intelligent Systems](http://onlinelibrary.wiley.com/rss/journal/10.1002/(ISSN)1098-111X)
- [Expert Systems](http://onlinelibrary.wiley.com/rss/journal/10.1111/(ISSN)1468-0394)
