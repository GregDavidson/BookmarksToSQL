# Directory: BookmarksToSQL

This project provides tools for storing Bookmarks from
popular browsers in a PostgreSQL database.

## Goals, i.e. Why Do This?

1. Easy maintenance of Bookmark Organization
- deduplicate links where cross-referencing not desired
- correct and optimize tags and folders
- merge in bookmarks from different browsers and sessions
2. Include subsets of bookmarks on selected web pages
- always serve latest matching bookmarks
3. Private and Secure Sync
- replace proprietary, unreliable and primitive syncing systems
3. Smart Social Bookmarking
- multiple users sync to same database
- users select what to share with specific folders and tags

## Roadmap:

1. ALMOST DONE: Translate Netscape/Firefox/Google-Chrome saved bookmark files into PostgreSQL SQL using XSLT.
2. Dedup & merge all bookmarks using SQL
3. Recreate a saved bookmark file using SQL & XSLT
4. Write SQL scripts to maintain links
5. Write SQL scripts to share selected links, e.g. on web pages
6. Write Browser add-ons to update bookmarks directly with the database
