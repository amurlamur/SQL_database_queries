-- Trigger to maintain the item count in the Invoice table based on changes in the InvoiceItem table.
CREATE OR ALTER TRIGGER InvoiceItemCountMaintenance
ON InvoiceItem
FOR INSERT, DELETE, UPDATE
AS
BEGIN
DECLARE @ItemCount INT
DECLARE @InvoiceID INT

-- Cursor to iterate through all invoices.
DECLARE curInvoice CURSOR FOR 
    SELECT ID FROM Invoice

OPEN curInvoice

FETCH NEXT FROM curInvoice INTO @InvoiceID
WHILE @@FETCH_STATUS = 0
BEGIN
    -- Update item count if new records are inserted.
    IF EXISTS (SELECT 1 FROM inserted i WHERE i.InvoiceID = @InvoiceID)
    BEGIN
        SELECT @ItemCount = SUM(Amount) FROM inserted i WHERE i.InvoiceID = @InvoiceID

        UPDATE Invoice SET ItemCount = ItemCount + @ItemCount WHERE ID = @InvoiceID
    END

    -- Update item count if records are deleted.
    IF EXISTS (SELECT 1 FROM deleted d WHERE d.InvoiceID = @InvoiceID)
    BEGIN
        SELECT @ItemCount = SUM(Amount) FROM deleted d WHERE d.InvoiceID = @InvoiceID

        UPDATE Invoice SET ItemCount = ItemCount - @ItemCount WHERE ID = @InvoiceID
    END

    FETCH NEXT FROM curInvoice INTO @InvoiceID
END

CLOSE curInvoice
DEALLOCATE curInvoice
END;
