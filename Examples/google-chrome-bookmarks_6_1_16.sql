SET search_path TO bookmarks_in;
SELECT
		( SELECT
				bookmark(f1,'http://xkcd.com/','xkcd: Map Age Guide','1464823693','','','') || 
			[] FROM bookmark_folder(f0,'','1464823384','1464823700','Bookmarks bar','') f1
		) ||
		( SELECT
				( SELECT
						bookmark(f2,'http://gregdavidson.github.io/','GregDavidson.GitHub.io by GregDavidson','1464823445','','','') || 
					[] FROM bookmark_folder(f1,'','1464823525','1464823603','GitHub','') f2
				) ||
				bookmark(f1,'http://jgd.ngender.net/','J. Greg Davidson','1464823493','','','') || 
			[] FROM bookmark_folder(f0,'','1464823562','1464823609','Greg','') f1
		) ||
		( SELECT
				bookmark(f1,'https://news.ycombinator.com/','Hacker News','1464823471','','','') || 
				bookmark(f1,'http://www.bbc.com/news','Home - BBC News','1464823484','','','') || 
				bookmark(f1,'http://www.worldpress.org/','Worldpress.org - World News From World Newspapers','1464823648','','','') || 
			[] FROM bookmark_folder(f0,'','1464823623','1464823693','News','') f1
		) ||
[] FROM NULLIF(0,0) f0;
