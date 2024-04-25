-- Filling up the new column with values.
UPDATE Invoice
SET ItemCount = (
    SELECT SUM(Amount)
    FROM InvoiceItem
    WHERE InvoiceItem.InvoiceID = Invoice.ID
)
