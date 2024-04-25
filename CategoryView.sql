-- Create a view to display categories along with their parent categories.
CREATE VIEW CategoryWithParent
AS
-- Select category name and its parent category name.
SELECT c.Name AS CategoryName, p.Name AS ParentCategoryName
FROM Category c
-- Left join with Category table to include parent category information.
LEFT OUTER JOIN Category p ON c.ParentCategoryId = p.ID;