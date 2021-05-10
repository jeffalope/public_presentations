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
	INSERT INTO dbo.EventLog (EventDate, EventType, UserID, ContentData)
	VALUES (@EventDate, @EventType, @UserID, @ContentData);
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
-- Add a compressed column and backfill it
--****************************************************************************
ALTER TABLE dbo.EventLog ADD CompressedContentData VARBINARY(MAX) NULL;
GO

BEGIN TRANSACTION 

EXEC sp_rename 'dbo.EventLog.ContentData', 'RawContentData', 'column';

ALTER TABLE dbo.EventLog ALTER COLUMN RawContentData NVARCHAR(MAX) NULL;

ALTER TABLE dbo.EventLog ADD ContentData AS 
	CASE 
		WHEN RawContentData IS NULL 
			THEN CAST(DECOMPRESS(CompressedContentData) AS NVARCHAR(MAX)) 
		ELSE RawContentData END;

COMMIT
GO

--****************************************************************************
-- Take a look at the event logs again
--	We can see that the original column holds the value but we have a new 
--	column with the same name as the original column that appears to be 
--	exactly the same.
--****************************************************************************
SELECT 
	EventID,
	RawContentData,
	CompressedContentData,
	ContentData
FROM dbo.EventLog;
GO

--****************************************************************************
-- Change the Procedure for logging events to compress the input
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

	DECLARE @CompressedContentData VARBINARY(MAX);

	SET @CompressedContentData = COMPRESS(@ContentData);

	INSERT INTO dbo.EventLog 
	(EventDate, EventType, UserID, CompressedContentData)
	VALUES (@EventDate, @EventType, @UserID, @CompressedContentData);
END;
GO

EXEC dbo.AddEventLog '2008-08-01 05:21:22.257','Question',13,N'Chris Jester-Young (UserId = 13) created a new question (PostId = 19) titled "What is the fastest way to get the value of π?" at "2008-08-01 05:21:22.257" with the body "<p>Solutions are welcome in any language. :-) I''m looking for the fastest way to obtain the value of π, as a personal challenge. More specifically I''m using ways that don''t involve using <code>#define</code>d constants like <code>M_PI</code>, or hard-coding the number in.</p>  <p>The program below tests the various ways I know of. The inline assembly version is, in theory, the fastest option, though clearly not portable; I''ve included it as a baseline to compare the other versions against. In my tests, with built-ins, the <code>4 * atan(1)</code> version is fastest on GCC 4.2, because it auto-folds the <code>atan(1)</code> into a constant. With <code>-fno-builtin</code> specified, the <code>atan2(0, -1)</code> version is fastest.</p>  <p>Here''s the main testing program (<code>pitimes.c</code>):</p>  <pre class="lang-c prettyprint-override"><code>#include &lt;math.h&gt; #include &lt;stdio.h&gt; #include &lt;time.h&gt;  #define ITERS 10000000 #define TESTWITH(x) {                                                       \     diff = 0.0;                                                             \     time1 = clock();                                                        \     for (i = 0; i &lt; ITERS; ++i)                                             \         diff += (x) - M_PI;                                                 \     time2 = clock();                                                        \     printf("%s\t=&gt; %e, time =&gt; %f\n", #x, diff, diffclock(time2, time1));   \ }  static inline double diffclock(clock_t time1, clock_t time0) {     return (double) (time1 - time0) / CLOCKS_PER_SEC; }  int main() {     int i;     clock_t time1, time2;     double diff;      /* Warmup. The atan2 case catches GCC''s atan folding (which would      * optimise the ``4 * atan(1) - M_PI'' to a no-op), if -fno-builtin      * is not used. */     TESTWITH(4 * atan(1))     TESTWITH(4 * atan2(1, 1))  #if defined(__GNUC__) &amp;&amp; (defined(__i386__) || defined(__amd64__))     extern double fldpi();     TESTWITH(fldpi()) #endif      /* Actual tests start here. */     TESTWITH(atan2(0, -1))     TESTWITH(acos(-1))     TESTWITH(2 * asin(1))     TESTWITH(4 * atan2(1, 1))     TESTWITH(4 * atan(1))      return 0; } </code></pre>  <p>And the inline assembly stuff (<code>fldpi.c</code>), noting that it will only work for x86 and x64 systems:</p>  <pre class="lang-c prettyprint-override"><code>double fldpi() {     double pi;     asm("fldpi" : "=t" (pi));     return pi; } </code></pre>  <p>And a build script that builds all the configurations I''m testing (<code>build.sh</code>):</p>  <pre><code>#!/bin/sh gcc -O3 -Wall -c           -m32 -o fldpi-32.o fldpi.c gcc -O3 -Wall -c           -m64 -o fldpi-64.o fldpi.c  gcc -O3 -Wall -ffast-math  -m32 -o pitimes1-32 pitimes.c fldpi-32.o gcc -O3 -Wall              -m32 -o pitimes2-32 pitimes.c fldpi-32.o -lm gcc -O3 -Wall -fno-builtin -m32 -o pitimes3-32 pitimes.c fldpi-32.o -lm gcc -O3 -Wall -ffast-math  -m64 -o pitimes1-64 pitimes.c fldpi-64.o -lm gcc -O3 -Wall              -m64 -o pitimes2-64 pitimes.c fldpi-64.o -lm gcc -O3 -Wall -fno-builtin -m64 -o pitimes3-64 pitimes.c fldpi-64.o -lm </code></pre>  <p>Apart from testing between various compiler flags (I''ve compared 32-bit against 64-bit too, because the optimisations are different), I''ve also tried switching the order of the tests around. The <code>atan2(0, -1)</code> version still comes out top every time, though.</p> "';
EXEC dbo.AddEventLog '2008-08-01 08:57:27.280','Answer',13,N'Chris Jester-Young (UserId = 13) answered a question (PostId = 21) at "2008-08-01 08:57:27.280" with the body "<p>Many years ago, to provide an <a href="http://cloud9.hedgee.com/age" rel="noreferrer">age calculator gimmick</a> on my website, I wrote a function to calculate age to a fraction. This is a quick port of that function to C# (from <a href="http://hedgee.svn.sourceforge.net/viewvc/hedgee/trunk/chris/ckwww/ckage.php3" rel="noreferrer">the PHP version</a>). I''m afraid I haven''t been able to test the C# version, but hope you enjoy all the same!</p>  <p>(Admittedly this is a bit gimmicky for the purposes of showing user profiles on Stack Overflow, but maybe readers will find some use for it. :-))</p>  <pre><code>double AgeDiff(DateTime date1, DateTime date2) {     double years = date2.Year - date1.Year;      /*      * If date2 and date1 + round(date2 - date1) are on different sides      * of 29 February, then our partial year is considered to have 366      * days total, otherwise it''s 365. Note that 59 is the day number      * of 29 Feb.      */     double fraction = 365             + (DateTime.IsLeapYear(date2.Year) &amp;&amp; date2.DayOfYear &gt;= 59             &amp;&amp; (date1.DayOfYear &lt; 59 || date1.DayOfYear &gt; date2.DayOfYear)             ? 1 : 0);      /*      * The only really nontrivial case is if date1 is in a leap year,      * and date2 is not. So let''s handle the others first.      */     if (DateTime.IsLeapYear(date2.Year) == DateTime.IsLeapYear(date1.Year))         return years + (date2.DayOfYear - date1.DayOfYear) / fraction;      /*      * If date2 is in a leap year, but date1 is not and is March or      * beyond, shift up by a day.      */     if (DateTime.IsLeapYear(date2.Year)) {         return years + (date2.DayOfYear - date1.DayOfYear                 - (date1.DayOfYear &gt;= 59 ? 1 : 0)) / fraction;     }      /*      * If date1 is not on 29 February, shift down date1 by a day if      * March or later. Proceed normally.      */     if (date1.DayOfYear != 59) {         return years + (date2.DayOfYear - date1.DayOfYear                 + (date1.DayOfYear &gt; 59 ? 1 : 0)) / fraction;     }      /*      * Okay, here date1 is on 29 February, and date2 is not on a leap      * year. What to do now? On 28 Feb in date2''s year, the ``age''      * should be just shy of a whole number, and on 1 Mar should be      * just over. Perhaps the easiest way is to a point halfway      * between those two: 58.5.      */     return years + (date2.DayOfYear - 58.5) / fraction; } </code></pre> "';
GO

--****************************************************************************
-- Take a look at the event logs again
--	We can see that the new rows only have their values compressed and 
--	computed on the fly.
--****************************************************************************
SELECT 
	EventID,
	RawContentData,
	CompressedContentData,
	ContentData
FROM dbo.EventLog;
GO