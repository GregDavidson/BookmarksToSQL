SET search_path TO bookmarks_in;
SELECT
		bookmark(f0,'place:folder=BOOKMARKS_MENU&folder=UNFILED_BOOKMARKS&folder=TOOLBAR&queryType=1&sort=12&maxResults=10&excludeQueries=1','Recently Bookmarked','1450735297','','1450735298','') || 
		bookmark(f0,'place:type=6&sort=14&maxResults=10','Recent Tags','1450735299','','1450735300','') || 
		( SELECT
			[] FROM bookmark_folder(f0,'','','','','') f1
		) ||
		bookmark(f0,'http://distrowatch.com/','DistroWatch','1304106401','','1304106407','') || 
		( SELECT
			[] FROM bookmark_folder(f0,'','','','','News and feature lists of Linux and BSD distributions.') f1
		) ||
		bookmark(f0,'http://segfault.linuxmint.com/','Segfault','1367943947','','1367943953','') || 
		( SELECT
			[] FROM bookmark_folder(f0,'','1304104956','1450735296','Bookmarks Toolbar','') f1
		) ||
		( SELECT
				bookmark(f1,'place:sort=8&maxResults=10','Most Visited','1450735296','','1450735296','') || 
				bookmark(f1,'http://www.linuxmint.com/','Linux Mint','1304106264','','1304106269','') || 
				( SELECT
					[] FROM bookmark_folder(f1,'','','','','Linux Mint is an elegant, easy to use, up to date and comfortable GNU/Linux desktop distribution.') f2
				) ||
				bookmark(f1,'http://community.linuxmint.com/','Community','1304106293','','1304106300','') || 
				bookmark(f1,'http://forums.linuxmint.com/','Forums','1304106305','','1304106312','') || 
				bookmark(f1,'http://blog.linuxmint.com/','Blog','1304106318','','1304106320','') || 
				( SELECT
					[] FROM bookmark_folder(f1,'','','','','') f2
				) ||
				bookmark(f1,'http://blog.linuxmint.com','News','','','','') || 
			[] FROM bookmark_folder(f0,'','','','','Add bookmarks to this folder to see them displayed on the Bookmarks Toolbar') f1
		) ||
[] FROM NULLIF(0,0) f0;
