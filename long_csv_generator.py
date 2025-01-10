import pandas as pd

def generate_csv(output_file="output_bus.csv"):

# Variables for ranges
    num_dates = 366  # Unique IDs in dates
    num_via = 1  # Unique IDs in via
    num_hours = 17  # Unique IDs in hours
    num_provinces = 32  # Unique IDs in provinces

# Create ranges for each column
    dates = list(range(1, num_dates + 1))  # Date Range: 1 to 366
    via = list(range(1, num_via + 1))  # Via Range: 1 to 1
    hours = list(range(1, num_hours + 1))  # Hours Range: 1 to 17
    provinces = list(range(1, num_provinces + 1))  # Provinces Range: 1 to 32

# Calculate the total number of rows required
    total_rows = len(dates) * len(via) * len(hours) * len(provinces)

# Expand each list to match the total rows
    col_date = [d for d in dates for _ in range(len(via) * len(hours) * len(provinces))]
    col_via = [v for _ in dates for v in via for _ in range(len(hours) * len(provinces))]
    col_hours = [h for _ in dates for _ in via for h in hours for _ in range(len(provinces))]
    col_provinces = [p for _ in dates for _ in via for _ in hours for p in provinces]

    # Create a DataFrame
    full_file = pd.DataFrame ({
        "id_date": col_date,
        "id_via": col_via,
        "id_hours": col_hours,
        "id_province": col_provinces,
    })

    # Validate the row count
    assert len(full_file) == total_rows, f"Expected {total_rows} rows, but got {len(full_file)} rows."

    # Print headers
    print(full_file.head())

    # Save to CSV
    full_file.to_csv(output_file, index=False)
    print(f"CSV file generated: {output_file}")

# Generate File
generate_csv()
