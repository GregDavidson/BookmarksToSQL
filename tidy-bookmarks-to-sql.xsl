<?xml version='1.0' encoding='utf-8'?>
<!--

This stylesheet transforms a tidy XML version of Netscape,
Firefox and Chrome bookmarks into PostgreSQL SQL code for
inserting the bookmarks into a PostgreSQL database.

Since the default bookmarks file is not saved in a
well-formed XML format by the browser, you will need to use
the tidy <http://tidy.sf.net/> utility to transform it into
a sanitized, well-formed XML format before using it with
this stylesheet.

Tidying your bookmark file and running this script can be
automated with the Makefile which should accompany this
script.

This script was inspired by a script by Suraj	N. Kurapati
for converting Netscape bookmark files into MindMap files.

Copyright 2016 J. Greg Davidson (to SQL)

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

Implementation Notes:
	Need to sanitize ALL data fields into proper quoted literals!
	Yes, ALL means numeric fields too!
	Need to ensure that ANY missing values are handled gracefully!
  Do missing text & attributes act like empty strings???

Data is currently sanitized by:
	<xsl:param name="xx">
	<xsl:value-of select='concat($q, translate($raw_xx, $q, $q2), $q)' />
	</xsl:param>
Caution: This requires that any PostgreSQL code be able to reverse the
translation!!
If we use on some xsltproc extensions we can instead sanitize with
something like:
	<xsl:param name="xx">
	<xsl:value-of select='concat($q, foo:replace($raw_xx, $q, $qq), $q)' />
	</xsl:param>
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:strip-space elements="*"/>	<!--?? -->
	<xsl:output method="text" omit-xml-declaration="yes" indent="yes" encoding="UTF-8"/>
	
	<xsl:variable name="newline" select="'&#010'" />
	<xsl:variable name="empty" select="''" />
	<xsl:variable name="space" select="' '" />
	<xsl:variable name="comma" select="','" />
	<xsl:variable name="rpar" select="')'" />
	
	<xsl:variable name="in1" select="$space" />  <!-- indent 1 space -->
	<!--  <xsl:variable name="in1" select="'&#09;'" /> -->  <!-- indent 1 tab -->
	<xsl:variable name="q" select='"&apos;"' />  <!-- 1 single quote -->
	<xsl:variable name="qq" select='"&apos;&apos;"' />  <!-- 2 single quotes -->
	<xsl:variable name="q2" select="'&#09;'" />  <!-- single quote alternative -->
	<!-- Warning: $q2 must be translated back into $q by SQL code receiving it!  -->
	
	<xsl:variable name="search_path" select="bookmarks_incoming" />
	
	<xsl:template match="html">
		<xsl:value-of select='concat("SET search_path TO", $search_path)' />
		<xsl:apply-templates select="body"/>
	</xsl:template>
	
	<!-- the root bookmark folder -->
	<xsl:template match="body">
		<xsl:value-of select='concat("SELECT", $newline)' />
		<xsl:apply-templates select="dl">
			<xsl:with-param name="level" select="1" />
			<xsl:with-param name="indent" select="$in1" />
		</xsl:apply-templates>
		<xsl:value-of select="[] FROM NULLIF(0,0) f0;" />
	</xsl:template>
	
	<!-- a list of bookmarks within a folder -->
	<xsl:template match="dl">
		<xsl:param name="level" select="1" />
		<xsl:param name="new_level" select="$level + 1" />
		<xsl:param name="indent" select="" />
		<xsl:param name="new_indent" select="concat($indent,$in1)" />
		<xsl:apply-templates>
			<xsl:with-param name="level" select="$new_level" />
			<xsl:with-param name="indent" select="$new_indent" />
		</xsl:apply-templates>
	</xsl:template>
	
	<!-- a folder which contains bookmarks -->
	<xsl:template match="dd">
		<xsl:param name="level" select="1" />
		<xsl:param name="new_level" select="$level + 1" />
		<xsl:param name="indent" select="" />
		<xsl:param name="new_indent" select="concat($indent,$in1)" />
		<xsl:param name="raw_folder_name">
			<xsl:value-of select='normalize-space(h3/text())'/>
		</xsl:param>
		<xsl:param name="folder_name">
			<xsl:value-of select='concat($q, translate($raw_folder_name, $q, $q2), $q)' />
		</xsl:param>
		<xsl:param name="raw_folder_description">
			<xsl:value-of select='normalize-space(text())'/>
		</xsl:param>
		<xsl:param name="folder_description">
			<xsl:value-of select='concat($q, translate($raw_folder_description, $q, $q2), $q)' />
		</xsl:param>
		<xsl:param name="raw_personal_toolbar_folder">
			<xsl:choose>
				<xsl:when test="h3/@personal_toolbar_folder='true'"> <xsl:value-of select="true" /> </xsl:when>
				<xsl:otherwise> <xsl:value-of select="false" /> </xsl:otherwise>
			</xsl:choose>
		</xsl:param>
		<xsl:param name="personal_toolbar_folder">
			<xsl:value-of select='concat($q, translate($raw_personal_toolbar_folder, $q, $q2), $q)' />
		</xsl:param>
		<xsl:param name="raw_add_date">
			<xsl:choose>
				<xsl:when test="h3/@add_date"> <xsl:value-of select="h3/@add_date" /> </xsl:when>
				<xsl:otherwise> <xsl:value-of select="NULL" /> </xsl:otherwise>
			</xsl:choose>
		</xsl:param>
		<xsl:param name="add_date">
			<xsl:value-of select='concat($q, translate($raw_add_date, $q, $q2), $q)' />
		</xsl:param>
		<xsl:param name="raw_last_modified">
			<xsl:choose>
				<xsl:when test="h3/@last_modified"> <xsl:value-of select="h3/@last_modified" />	</xsl:when>
				<xsl:otherwise> <xsl:value-of select="NULL" /> </xsl:otherwise>
			</xsl:choose>
		</xsl:param>
		<xsl:param name="last_modified">
			<xsl:value-of select='concat($q, translate($raw_last_modified, $q, $q2), $q)' />
		</xsl:param>
		<xsl:param name="left" select='concat($indent, "( SELECT", $newline)' />
		<xsl:param name="from" select='concat($indent, "[] FROM bookmark_folder(")' />
		<xsl:param name="right" select='concat($indent, " ) ||", $newline)' />
		<xsl:param name="old_f" select='concat("f",$level)' />
		<xsl:param name="old_f_" select='concat($old_f, $comma)' />
		<xsl:param name="new_f" select='concat("f",$new_level)' />
		<xsl:param name="ptf_" select='concat($personal_toolbar_folder, $comma)' />
		<xsl:param name="added_" select='concat($add_date, $comma)' />
		<xsl:param name="modified_" select='concat($last_modified, $comma)' />
		<xsl:param name="fname_" select='concat($folder_name, $comma)' />
		<xsl:param name="fdesc__" select='concat($folder_description, $rpar, $space)' /> <!-- note delims! -->
		<!-- ( SELECT { bookmarks array ... || } [] FROM bookmark_folder(f{indent}, ...) f{new_indent} ) || -->
		<xsl:value-of select='$left' />
		<xsl:apply-templates>
			<xsl:with-param name="level" select="$new_level" />
			<xsl:with-param name="indent" select="$new_indent" />
		</xsl:apply-templates>
		<xsl:value-of select='concat($from, $old_f_, $ptf_, $added_, $modified_, $fname_, $fdesc__, $new_f)' />
		<xsl:value-of select='$right' />
	</xsl:template>
	
	<!-- a bookmark -->
	<xsl:template match="dt">
		<xsl:param name="level" select="1" />
		<xsl:param name="folder" select='concat("f",$level)' />
		<xsl:param name="indent" select="" />
		<xsl:param name="raw_link" select="a/@href"/>
		<xsl:param name="link">
			<xsl:value-of select='concat($q, translate($raw_link, $q, $q2), $q)' />
		</xsl:param>
		<xsl:param name="raw_title" select="a/text()"/>
		<xsl:param name="title">
			<xsl:value-of select='concat($q, translate($raw_title, $q, $q2), $q)' />
		</xsl:param>
		
	</xsl:template>
	
	<!-- ignore everything else in the bookmarks file -->
	<xsl:template match="node()|@*"/>
	
</xsl:stylesheet>
