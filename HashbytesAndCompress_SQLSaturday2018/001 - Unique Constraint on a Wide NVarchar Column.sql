USE SampleData 
GO

--****************************************************************************
-- Cleanup the table if it exists 
--****************************************************************************
DROP TABLE IF EXISTS dbo.ProductPage;


--****************************************************************************
-- Create the table 
--	notice the PK is on an identity column to ensure uniqueness
--****************************************************************************
CREATE TABLE dbo.ProductPage 
(
	ProductPageID INT IDENTITY (1,1) NOT NULL,
	PageUrl NVARCHAR(1000) NOT NULL,
	QuantityAvailable INT NULL,
	Price MONEY NULL,
	ProductTitle NVARCHAR(200) NOT NULL,
	LastUpdateDateUTC DATETIME2(3) NOT NULL,
	CONSTRAINT PK_ProductPage PRIMARY KEY (ProductPageID)
);

--****************************************************************************
-- Create a unique constraint on the table as the PageURL is a natural key for our dataset
--	Oh no though, we get "Warning! The maximum key length for a nonclustered index is 1700 bytes"
--	Well its ok right, no fool would have a URL that long right...?
--****************************************************************************
ALTER TABLE dbo.ProductPage ADD CONSTRAINT UQ_ProductPage_PageUrl UNIQUE (PageUrl);

--****************************************************************************
-- Insert information about a product page for a sane offer page
--****************************************************************************
INSERT INTO dbo.ProductPage (PageUrl, QuantityAvailable, Price, ProductTitle, LastUpdateDateUTC)
SELECT 
	N'https://www.newegg.com/Product/Product.aspx?Item=9SIA9K85ZF1380&cm_re=echo-_-81-511-006-_-Product' AS PageUrl, 
	10 AS QuantityAvailable, 
	45.38 AS Price, 
	N'Amazon Echo Dot (2nd Generation) - Black' AS ProductTitle, 
	'2018-04-08 18:14:55.807' AS LastUpdateDateUTC;
	
--****************************************************************************
-- Insert information about a product page for less ideal offer page
--	Oh no, we get "Operation failed. The index entry of length 1946 bytes for the index 'UQ_ProductPage_PageUrl' exceeds the maximum length of 1700 bytes for nonclustered indexes."
--****************************************************************************
INSERT INTO dbo.ProductPage (PageUrl, QuantityAvailable, Price, ProductTitle, LastUpdateDateUTC)
SELECT 
	N'https://www.amazon.co.jp/PHILIPS-%E3%83%AF%E3%82%A4%E3%83%A4%E3%83%AC%E3%82%B9%E3%82%B9%E3%83%9D%E3%83%BC%E3%83%84%E3%82%A4%E3%83%A4%E3%83%9B%E3%83%B3-Bluetooth%E3%83%BBNFC%E5%AF%BE%E5%BF%9C-%E3%83%AA%E3%83%A2%E3%82%B3%E3%83%B3%E3%83%BB%E3%83%9E%E3%82%A4%E3%82%AF%E4%BB%98-MusicChain%E6%A9%9F%E8%83%BD%E3%81%A7%E9%9F%B3%E6%A5%BD%E3%82%92%E3%82%B7%E3%82%A7%E3%82%A2%E3%81%A7%E3%81%8D%E3%82%8B%E3%82%BB%E3%83%83%E3%83%88%E3%80%90%E5%9B%BD%E5%86%85%E6%AD%A3%E8%A6%8F%E5%93%81%E3%80%91/dp/B01KX5TSDQ?m=AN1VRQENFRJN5&path=PHILIPS-%E3%83%AF%E3%82%A4%E3%83%A4%E3%83%AC%E3%82%B9%E3%82%B9%E3%83%9D%E3%83%BC%E3%83%84%E3%82%A4%E3%83%A4%E3%83%9B%E3%83%B3-Bluetooth%E3%83%BBNFC%E5%AF%BE%E5%BF%9C-%E3%83%AA%E3%83%A2%E3%82%B3%E3%83%B3%E3%83%BB%E3%83%9E%E3%82%A4%E3%82%AF%E4%BB%98-MusicChain%E6%A9%9F%E8%83%BD%E3%81%A7%E9%9F%B3%E6%A5%BD%E3%82%92%E3%82%B7%E3%82%A7%E3%82%A2%E3%81%A7%E3%81%8D%E3%82%8B%E3%82%BB%E3%83%83%E3%83%88%E3%80%90%E5%9B%BD%E5%86%85%E6%AD%A3%E8%A6%8F%E5%93%81%E3%80%91' AS PageUrl, 
	10 AS QuantityAvailable, 
	45.38 AS Price, 
	N'Amazon Echo Dot (2nd Generation) - Black' AS ProductTitle, 
	'2018-04-08 18:14:55.807' AS LastUpdateDateUTC;

--****************************************************************************
-- Drop that unique constraint
--****************************************************************************
ALTER TABLE dbo.ProductPage DROP CONSTRAINT UQ_ProductPage_PageUrl;

--****************************************************************************
-- Create a computed column (a hash of the PageUrl) 
--****************************************************************************
ALTER TABLE dbo.ProductPage ADD PageUrlHash AS CAST(HASHBYTES('SHA1', PageUrl) AS VARBINARY(20)) PERSISTED;

--****************************************************************************
-- Create a unique constraint on the hash value
--****************************************************************************
ALTER TABLE dbo.ProductPage ADD CONSTRAINT UQ_ProductPage_PageUrlHash UNIQUE (PageUrlHash);

--****************************************************************************
-- Insert information about a product page for less ideal product page
--****************************************************************************
INSERT INTO dbo.ProductPage (PageUrl, QuantityAvailable, Price, ProductTitle, LastUpdateDateUTC)
SELECT 
	N'https://www.amazon.co.jp/PHILIPS-%E3%83%AF%E3%82%A4%E3%83%A4%E3%83%AC%E3%82%B9%E3%82%B9%E3%83%9D%E3%83%BC%E3%83%84%E3%82%A4%E3%83%A4%E3%83%9B%E3%83%B3-Bluetooth%E3%83%BBNFC%E5%AF%BE%E5%BF%9C-%E3%83%AA%E3%83%A2%E3%82%B3%E3%83%B3%E3%83%BB%E3%83%9E%E3%82%A4%E3%82%AF%E4%BB%98-MusicChain%E6%A9%9F%E8%83%BD%E3%81%A7%E9%9F%B3%E6%A5%BD%E3%82%92%E3%82%B7%E3%82%A7%E3%82%A2%E3%81%A7%E3%81%8D%E3%82%8B%E3%82%BB%E3%83%83%E3%83%88%E3%80%90%E5%9B%BD%E5%86%85%E6%AD%A3%E8%A6%8F%E5%93%81%E3%80%91/dp/B01KX5TSDQ?m=AN1VRQENFRJN5&path=PHILIPS-%E3%83%AF%E3%82%A4%E3%83%A4%E3%83%AC%E3%82%B9%E3%82%B9%E3%83%9D%E3%83%BC%E3%83%84%E3%82%A4%E3%83%A4%E3%83%9B%E3%83%B3-Bluetooth%E3%83%BBNFC%E5%AF%BE%E5%BF%9C-%E3%83%AA%E3%83%A2%E3%82%B3%E3%83%B3%E3%83%BB%E3%83%9E%E3%82%A4%E3%82%AF%E4%BB%98-MusicChain%E6%A9%9F%E8%83%BD%E3%81%A7%E9%9F%B3%E6%A5%BD%E3%82%92%E3%82%B7%E3%82%A7%E3%82%A2%E3%81%A7%E3%81%8D%E3%82%8B%E3%82%BB%E3%83%83%E3%83%88%E3%80%90%E5%9B%BD%E5%86%85%E6%AD%A3%E8%A6%8F%E5%93%81%E3%80%91' AS PageUrl, 
	10 AS QuantityAvailable, 
	45.38 AS Price, 
	N'Amazon Echo Dot (2nd Generation) - Black' AS ProductTitle, 
	'2018-04-08 18:14:55.807' AS LastUpdateDateUTC;

--****************************************************************************
-- Insert information about a product page for less ideal product page a second time
--****************************************************************************
INSERT INTO dbo.ProductPage (PageUrl, QuantityAvailable, Price, ProductTitle, LastUpdateDateUTC)
SELECT 
	N'https://www.amazon.co.jp/PHILIPS-%E3%83%AF%E3%82%A4%E3%83%A4%E3%83%AC%E3%82%B9%E3%82%B9%E3%83%9D%E3%83%BC%E3%83%84%E3%82%A4%E3%83%A4%E3%83%9B%E3%83%B3-Bluetooth%E3%83%BBNFC%E5%AF%BE%E5%BF%9C-%E3%83%AA%E3%83%A2%E3%82%B3%E3%83%B3%E3%83%BB%E3%83%9E%E3%82%A4%E3%82%AF%E4%BB%98-MusicChain%E6%A9%9F%E8%83%BD%E3%81%A7%E9%9F%B3%E6%A5%BD%E3%82%92%E3%82%B7%E3%82%A7%E3%82%A2%E3%81%A7%E3%81%8D%E3%82%8B%E3%82%BB%E3%83%83%E3%83%88%E3%80%90%E5%9B%BD%E5%86%85%E6%AD%A3%E8%A6%8F%E5%93%81%E3%80%91/dp/B01KX5TSDQ?m=AN1VRQENFRJN5&path=PHILIPS-%E3%83%AF%E3%82%A4%E3%83%A4%E3%83%AC%E3%82%B9%E3%82%B9%E3%83%9D%E3%83%BC%E3%83%84%E3%82%A4%E3%83%A4%E3%83%9B%E3%83%B3-Bluetooth%E3%83%BBNFC%E5%AF%BE%E5%BF%9C-%E3%83%AA%E3%83%A2%E3%82%B3%E3%83%B3%E3%83%BB%E3%83%9E%E3%82%A4%E3%82%AF%E4%BB%98-MusicChain%E6%A9%9F%E8%83%BD%E3%81%A7%E9%9F%B3%E6%A5%BD%E3%82%92%E3%82%B7%E3%82%A7%E3%82%A2%E3%81%A7%E3%81%8D%E3%82%8B%E3%82%BB%E3%83%83%E3%83%88%E3%80%90%E5%9B%BD%E5%86%85%E6%AD%A3%E8%A6%8F%E5%93%81%E3%80%91' AS PageUrl, 
	10 AS QuantityAvailable, 
	45.38 AS Price, 
	N'Amazon Echo Dot (2nd Generation) - Black' AS ProductTitle, 
	'2018-04-08 18:14:55.807' AS LastUpdateDateUTC;


