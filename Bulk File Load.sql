LOAD DATA INFILE "file path" -- file path
INTO TABLE “tablename’
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(col1,col2,coln) -- columns