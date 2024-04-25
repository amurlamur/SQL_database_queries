-- Procedure to check the consistency between invoice and order item amounts.
CREATE OR ALTER PROCEDURE CheckInvoice
    @invoiceid INT
AS
BEGIN
    DECLARE @Name NVARCHAR(256) -- Variable to store item name.
    DECLARE @ReturnValue INT = 0 -- Variable to indicate the result of the check (0 for success, 1 for failure).
    DECLARE @First INT
    DECLARE @Second INT
    
    -- Cursor to iterate through invoice items and their corresponding order items.
    DECLARE cur CURSOR FOR 
        SELECT It.Amount, oi.Amount, It.Name
        FROM Invoice i
        INNER JOIN InvoiceItem It ON i.ID = It.InvoiceID
        INNER JOIN OrderItem oi ON oi.ID = It.OrderItemID
        WHERE i.ID = @invoiceid

    OPEN cur
    FETCH NEXT FROM cur INTO @First, @Second, @Name

    -- Loop through the cursor results.
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Compare amounts from invoice and order item.
        IF @First <> @Second
        BEGIN
            -- Print error message if amounts don't match.
            PRINT 'Error: ' + @Name + ' (invoice ' + CONVERT(VARCHAR(5), @First) + ' order ' + CONVERT(VARCHAR(5), @Second) + ')' 
            SET @ReturnValue = 1 -- Set return value to indicate failure.
        END

        FETCH NEXT FROM cur INTO @First, @Second, @Name
    END

    CLOSE cur -- Close cursor.
    DEALLOCATE cur -- Deallocate cursor memory.

    RETURN @ReturnValue -- Return result of the check.
END
