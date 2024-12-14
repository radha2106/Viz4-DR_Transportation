# Dominican Republic Transportation Tracker

This project for the Dominican Republic's transportation system highlights several key metrics:

- It displays the average number of passengers transported per hour, allowing for the identification of peak times.
- Tracks daily revenue for the selected month to facilitate trend analysis.
- Sets clear passenger and revenue goals as benchmarks, etc

This comprehensive overview enables stakeholders to make informed, data-driven decisions regarding transportation performance.
## Documentation

### Steps in Excel
- Add a maximum and a minimum number for method of transportation.
- Make a calculation for each hour and make percentage results based on the maximun and minimum value
- Use randbetween to get value between the 2 results returned.
- Increase the maximum and a minimum values for each year

### Steps for SQL
- Create tables with necessary columns
- Create a calendar table
- Create a hour table
- Create a table for method of transportation
- Create a all-in table info (this table will serve to separate types of transportation)
- Create views for maximum passangers based on method of transportation

## Steps in PBI
- Connect PBI query to ODBC query and import the tables
- Make relationship between tables
- Create necessary meassures in an additional folder
- Use a palette color of 2-3 colors

Better SQL details here: 
- [SQL Table Snap](https://github.com/radha2106/Viz4-DR_Transportation/tree/main/sql_snaps).
- [SQL Full Code](https://github.com/radha2106/Viz4-DR_Transportation/blob/main/Transport_Database_Creation_and_Tables.sql)

Better PBI details here:
- Meassure are here: [DAX Codes](https://github.com/radha2106/Viz4-DR_Transportation/blob/main/DAX%20Formulas).
- [Data Modeling](https://github.com/radha2106/Viz4-DR_Transportation/blob/main/DataModel.png)

Full Dashboard is here:
- [Viz3](https://project.novypro.com/HH9naZ)

## Colors Used Reference

| Colors             | Hex Value                                                               |
| ----------------- | ------------------------------------------------------------------ |
| Base Color | ![#18E6BF](https://via.placeholder.com/10/18E6BF?text=+) #18E6BF |
| Background Color | ![#14141E](https://via.placeholder.com/10/14141E?text=+) #14141E |
| Text Color | ![#E9EFEC](https://via.placeholder.com/10/E9EFEC?text=+) #E9EFEC |
