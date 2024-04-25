DECLARE @invoiceid INT -- Variable to store invoice ID.
DECLARE @checkresult INT -- Variable to store the result of the invoice check.

-- Cursor to iterate through all invoices.
DECLARE invoice_cursor CURSOR FOR
SELECT ID FROM Invoice

OPEN invoice_cursor
FETCH NEXT FROM invoice_cursor INTO @invoiceid

-- Loop through invoices.
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'InvoiceID: ' + CAST(@invoiceid AS VARCHAR(10)) -- Print current invoice ID.

    -- Execute CheckInvoice procedure for the current invoice.
    EXEC @checkresult = CheckInvoice @invoiceid

    -- Check the result of the invoice check.
    IF @checkresult = 0
    BEGIN
        PRINT 'Invoice ok' -- Print message if invoice is consistent.
    END

    FETCH NEXT FROM invoice_cursor INTO @invoiceid -- Move to the next invoice.
END

CLOSE invoice_cursor -- Close cursor.
DEALLOCATE invoice_cursor -- Deallocate cursor memory.
