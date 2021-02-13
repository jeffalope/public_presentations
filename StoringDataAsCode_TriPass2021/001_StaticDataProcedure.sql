/***********************************************************************
	Create the table to store the lookup data for different types of toast
***********************************************************************/
DROP TABLE IF EXISTS dbo.ToastTypes;
GO

CREATE TABLE dbo.ToastTypes
(
	ToastTypeID INT NOT NULL,
	ToastTypeName VARCHAR(20) NOT NULL,
	PRIMARY KEY (ToastTypeID)
);
GO

/***********************************************************************
	Create the procedure to Insert/Update/Delete the toast types
***********************************************************************/
CREATE OR ALTER PROCEDURE dbo.PopulateLookup_ToastTypes
AS
BEGIN

	DECLARE @LookupData TABLE
	(
		ToastTypeID INT NOT NULL,
		ToastTypeName VARCHAR(20) NOT NULL,
		PRIMARY KEY (ToastTypeID)	
	);

	INSERT INTO @LookupData (ToastTypeID, ToastTypeName)
	SELECT ToastTypeID, ToastTypeName
	FROM 
	(VALUES 
		(1, 'Avocado Toast'),
		(2, 'Buttered Toast'),
		(3, 'Jelly Toast'),
		(4, 'French Toast')
	)t (ToastTypeID, ToastTypeName);

	INSERT INTO dbo.ToastTypes (ToastTypeID, ToastTypeName)
	SELECT ToastTypeID, ToastTypeName
	FROM @LookupData ld
	WHERE 
		NOT EXISTS 
		(
			SELECT * 
			FROM dbo.ToastTypes tt 
			WHERE 
				ld.ToastTypeID = tt.ToastTypeID
		);

	UPDATE tt
	SET tt.ToastTypeName = ld.ToastTypeName
	FROM dbo.ToastTypes tt
	INNER JOIN @LookupData ld
		ON tt.ToastTypeID = ld.ToastTypeID
	WHERE
		tt.ToastTypeName <> ld.ToastTypeName;

	DELETE tt
	FROM dbo.ToastTypes tt
	WHERE 
		NOT EXISTS 
		(
			SELECT *
			FROM @LookupData  ld
			WHERE 
				tt.ToastTypeID = ld.ToastTypeID
		);
END
GO

/***********************************************************************
	Verify that the table is empty
***********************************************************************/
SELECT ToastTypeID, ToastTypeName
FROM dbo.ToastTypes;

/***********************************************************************
	Populate the table using the procedure
***********************************************************************/
EXEC dbo.PopulateLookup_ToastTypes;

/***********************************************************************
	Verify that the table is populated as expected
***********************************************************************/
SELECT ToastTypeID, ToastTypeName 
FROM dbo.ToastTypes;

/***********************************************************************
	Someone breaks the rules, probably someone named Trip.  Seems like 
	a Trip thing to do.  No offense to anyone named Trip that knows 
	better than to ruin things.
***********************************************************************/
INSERT INTO dbo.ToastTypes (ToastTypeID, ToastTypeName)
VALUES (-1, 'Wedding Toast');

/***********************************************************************
	Verify that the table has the mistake
***********************************************************************/
SELECT ToastTypeID, ToastTypeName 
FROM dbo.ToastTypes;

/***********************************************************************
	Populate the table using the procedure
***********************************************************************/
EXEC dbo.PopulateLookup_ToastTypes;

/***********************************************************************
	Verify that the table is populated as expected
***********************************************************************/
SELECT ToastTypeID, ToastTypeName 
FROM dbo.ToastTypes;

/***********************************************************************
	Some additional considerations

	1) Add a sql job/recurring process to routinue execute the procedure
		to try to combat mistakes being made and not caught

	2) Add logic to deployment processes to recognize that static data
		was modified and might need to be refreshed.  You could also
		just always execute the refresh

	3) Create a single procedure that executes all of your lookup 
		so that you can ensure none of them are missed.  It could be 
		hardcoded or if you used fixed format you could just loop
		over all the procedures with a given name format.
***********************************************************************/
