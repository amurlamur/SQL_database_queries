CREATE OR ALTER TRIGGER InsertCategoryWithParent -- name of the trigger
ON CategoryWithParent -- name of the view
INSTEAD of INSERT    -- trigger code executed insted of insert
AS
BEGIN
  DECLARE @newname NVARCHAR(255) -- variables used below
  DECLARE @parentname NVARCHAR(255)
  DECLARE @parentid INT

  -- using a cursor to navigate the inserted table
  DECLARE ic CURSOR for SELECT * FROM inserted
  OPEN ic
  -- standard way of managing a cursor
  FETCH NEXT FROM ic INTO @newname, @parentname
  WHILE @@FETCH_STATUS = 0
  BEGIN
    -- check the received values available in the variables
	IF @parentname IS NOT NULL
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM Category WHERE Name = @parentname)
		BEGIN
		 RAISERROR('Parent category does not exist.', 16, 1)
		END
	ELSE 
		BEGIN
		SELECT @parentid = ID FROM Category WHERE Name = @parentname
		END
	END
	 IF EXISTS (SELECT 1 FROM Category WHERE Name = @newname)
    BEGIN
      RAISERROR('Category name already exists.', 16, 1)
      RETURN
    END
	INSERT INTO Category (Name, ParentCategoryID)
    SELECT @newname, @parentid
    FETCH NEXT FROM ic INTO @newname, @parentname
  END

  CLOSE ic -- finish cursor usage
  DEALLOCATE ic
END