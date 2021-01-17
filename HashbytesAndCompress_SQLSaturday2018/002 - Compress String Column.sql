USE SampleData

--****************************************************************************
-- Cleanup the table if it exists 
--****************************************************************************
DROP TABLE IF EXISTS dbo.EventLog;
GO

--****************************************************************************
-- Create a table for storing EventLogs
--****************************************************************************
CREATE TABLE [dbo].[EventLog](
	[EventID] [int] IDENTITY(1,1) NOT NULL,
	[EventDate] [datetime] NOT NULL,
	[EventType] [varchar](50) NOT NULL,
	[UserID] [int] NOT NULL,
	[ContentData] [nvarchar](max) NOT NULL,
	CONSTRAINT [PK_EventLog] PRIMARY KEY CLUSTERED 
	(
		[EventID] ASC
	)
);
GO

--****************************************************************************
-- Create a Procedure for logging events
--****************************************************************************

CREATE OR ALTER PROCEDURE dbo.AddEventLog
(
@EventDate DATETIME,
@EventType VARCHAR(50),
@UserID INT,
@ContentData NVARCHAR(MAX)
)
AS
BEGIN
	INSERT INTO dbo.EventLog VALUES (@EventDate, @EventType, @UserID, @ContentData);
END;
GO

--****************************************************************************
-- Create some events
--****************************************************************************
EXEC dbo.AddEventLog '2008-07-31 21:42:52.667',N'Question',8,N'Eggs McLaren (UserId = 8) created a new question (PostId = 4) titled "While applying opacity to a form, should we use a decimal or a double value?" at "2008-07-31 21:42:52.667" with the body "<p>I want to use a track-bar to change a form''s opacity.</p>  <p>This is my code:</p>  <pre><code>decimal trans = trackBar1.Value / 5000; this.Opacity = trans; </code></pre>  <p>When I build the application, it gives the following error:</p>  <blockquote>   <p>Cannot implicitly convert type <code>''decimal''</code> to <code>''double''</code>.</p> </blockquote>  <p>I tried using <code>trans</code> and <code>double</code> but then the control doesn''t work. This code worked fine in a past VB.NET project.</p> "';
EXEC dbo.AddEventLog '2008-07-31 22:08:08.620','Question',9,N'Kevin Dente (UserId = 9) created a new question (PostId = 6) titled "Percentage width child element in absolutely positioned parent on Internet Explorer 7" at "2008-07-31 22:08:08.620" with the body "<p>I have an absolutely positioned <code>div</code> containing several children, one of which is a relatively positioned <code>div</code>. When I use a <strong>percentage-based width</strong> on the child <code>div</code>, it collapses to ''0'' width on <a href="http://en.wikipedia.org/wiki/Internet_Explorer_7" rel="noreferrer">Internet&nbsp;Explorer&nbsp;7</a>, but not on Firefox or Safari.</p>  <p>If I use <strong>pixel width</strong>, it works. If the parent is relatively positioned, the percentage width on the child works.</p>  <ol> <li>Is there something I''m missing here?</li> <li>Is there an easy fix for this besides the <em>pixel-based width</em> on the child?</li> <li>Is there an area of the CSS specification that covers this?</li> </ol> "';
EXEC dbo.AddEventLog '2008-07-31 22:17:57.883','Answer',9,N'Kevin Dente (UserId = 9) answered a question (PostId = 7) at "2008-07-31 22:17:57.883" with the body "<p>An explicit cast to double isn''t necessary.</p>  <pre><code>double trans = (double)trackBar1.Value / 5000.0; </code></pre>  <p>Identifying the constant as <code>5000.0</code> (or as <code>5000d</code>) is sufficient:</p>  <pre><code>double trans = trackBar1.Value / 5000.0; double trans = trackBar1.Value / 5000d; </code></pre> "';
EXEC dbo.AddEventLog '2008-07-31 23:40:59.743','Question',1,N'Jeff Atwood (UserId = 1) created a new question (PostId = 9) titled "How do I calculate someone''s age in C#?" at "2008-07-31 23:40:59.743" with the body "<p>Given a <code>DateTime</code> representing a person''s birthday, how do I calculate their age in years?  </p> "';
EXEC dbo.AddEventLog '2008-07-31 23:55:37.967','Question',1,N'Jeff Atwood (UserId = 1) created a new question (PostId = 11) titled "Calculate relative time in C#" at "2008-07-31 23:55:37.967" with the body "<p>Given a specific <code>DateTime</code> value, how do I display relative time, like:</p>  <ul> <li>2 hours ago</li> <li>3 days ago</li> <li>a month ago</li> </ul> "';
EXEC dbo.AddEventLog '2008-07-31 23:56:41.303','Answer',1,N'Jeff Atwood (UserId = 1) answered a question (PostId = 12) at "2008-07-31 23:56:41.303" with the body "<p>Well, here''s how we do it on Stack Overflow.</p>  <pre class="lang-csharp prettyprint-override"><code>var ts = new TimeSpan(DateTime.UtcNow.Ticks - dt.Ticks); double delta = Math.Abs(ts.TotalSeconds);  if (delta &lt; 60) {   return ts.Seconds == 1 ? "one second ago" : ts.Seconds + " seconds ago"; } if (delta &lt; 120) {   return "a minute ago"; } if (delta &lt; 2700) // 45 * 60 {   return ts.Minutes + " minutes ago"; } if (delta &lt; 5400) // 90 * 60 {   return "an hour ago"; } if (delta &lt; 86400) // 24 * 60 * 60 {   return ts.Hours + " hours ago"; } if (delta &lt; 172800) // 48 * 60 * 60 {   return "yesterday"; } if (delta &lt; 2592000) // 30 * 24 * 60 * 60 {   return ts.Days + " days ago"; } if (delta &lt; 31104000) // 12 * 30 * 24 * 60 * 60 {   int months = Convert.ToInt32(Math.Floor((double)ts.Days / 30));   return months &lt;= 1 ? "one month ago" : months + " months ago"; } int years = Convert.ToInt32(Math.Floor((double)ts.Days / 365)); return years &lt;= 1 ? "one year ago" : years + " years ago"; </code></pre>  <p>Suggestions? Comments? Ways to improve this algorithm?</p> "';
EXEC dbo.AddEventLog '2008-08-01 00:42:38.903','Question',9,N'Kevin Dente (UserId = 9) created a new question (PostId = 13) titled "Determine a User''s Timezone" at "2008-08-01 00:42:38.903" with the body "<p>Is there any standard way for a Web Server to be able to determine a user''s timezone within a web page? Perhaps from a HTTP header or part of the user-agent string?</p> "';
EXEC dbo.AddEventLog '2008-08-01 00:59:11.177','Question',11,N'Anonymous User (UserId = 11) created a new question (PostId = 14) titled "Difference between Math.Floor() and Math.Truncate()" at "2008-08-01 00:59:11.177" with the body "<p>What is the difference between <a href="http://msdn.microsoft.com/en-us/library/9a6a2sxy.aspx" rel="noreferrer"><code>Math.Floor()</code></a> and <a href="http://msdn.microsoft.com/en-us/library/system.math.truncate.aspx" rel="noreferrer"><code>Math.Truncate()</code></a> in .NET?</p> "';
EXEC dbo.AddEventLog '2008-08-01 04:59:33.643','Question',2,N'Geoff Dalgas (UserId = 2) created a new question (PostId = 16) titled "Filling a DataSet or DataTable from a LINQ query result set" at "2008-08-01 04:59:33.643" with the body "<p>How do you expose a LINQ query as an ASMX web service? Usually, from the business tier, I can return a typed <code>DataSet</code> or <code>DataTable</code> which can be serialized for transport over ASMX.</p>  <p>How can I do the same for a LINQ query? Is there a way to populate a typed <code>DataSet</code> or <code>DataTable</code> via a LINQ query?</p>  <pre><code>public static MyDataTable CallMySproc() {     string conn = "...";      MyDatabaseDataContext db = new MyDatabaseDataContext(conn);     MyDataTable dt = new MyDataTable();      // execute a sproc via LINQ     var query = from dr                 in db.MySproc().AsEnumerable                 select dr;      // copy LINQ query resultset into a DataTable -this does not work !         dt = query.CopyToDataTable();      return dt; } </code></pre>  <p>How can I get the result set of a LINQ query into a <code>DataSet</code> or <code>DataTable</code>? Alternatively, is the LINQ query serializeable so that I can expose it as an ASMX web service?</p> "';
EXEC dbo.AddEventLog '2008-08-01 05:09:55.993','Question',2,N'Geoff Dalgas (UserId = 2) created a new question (PostId = 17) titled "Binary Data in MySQL" at "2008-08-01 05:09:55.993" with the body "<p>How do I store binary data in <a href="http://en.wikipedia.org/wiki/MySQL" rel="noreferrer">MySQL</a>?</p> "';
GO

--****************************************************************************
-- Take a look at the event data
--****************************************************************************
SELECT 
	EventID,
	ContentData
FROM dbo.EventLog
WHERE 
	EventDate = '2008-07-31 21:42:52.667';
GO

--****************************************************************************
-- Add a compressed column
--****************************************************************************
ALTER TABLE dbo.EventLog ADD CompressedContentData as COMPRESS(ContentData);
GO

--****************************************************************************
-- Query the CompressedContentData column and also run it through the DECOMPRESS function
--****************************************************************************
SELECT 
	EventID,
	ContentData,
	CompressedContentData,
	CAST(DECOMPRESS(CompressedContentData) AS NVARCHAR(MAX)) as DecompressedContentData
FROM dbo.EventLog
WHERE 
	EventDate = '2008-07-31 21:42:52.667';
GO