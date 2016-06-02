# Directory: BookmarksToSQL

This project provides tools for storing Bookmarks from
popular browsers in a PostgreSQL database.

## Goals, i.e. Why Do This?

1. Easy maintenance of Bookmark Organization
  * Deduplicate links where cross-referencing not desired
  * Correct and optimize tags and folders
  * Merge in bookmarks from different browsers and sessions
2. Include subsets of bookmarks on selected web pages
  * Serve latest matching bookmarks
3. Private and Secure Sync
  * Replace proprietary, unreliable and primitive syncing systems
4. Smart Social Bookmarking
  * Multiple users sync to same database
  * Users select what to share by Folder and Tag
5. Full SQL Queries for Bookmarks
  * What would this let you do?  

## Roadmap:

1. ALMOST DONE: Translate Netscape/Firefox/Google-Chrome saved bookmark files into PostgreSQL SQL using XSLT.
2. Dedup & merge all bookmarks using SQL
3. Recreate a saved bookmark file using SQL & XSLT
4. Write SQL scripts to maintain links
5. Write SQL scripts to share selected links, e.g. on web pages
6. Write Browser add-ons to update bookmarks directly with the database
