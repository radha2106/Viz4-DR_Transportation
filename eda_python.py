import pandas as pd
import numpy as np

# Read Files and only use few columns
calendar = pd.read_csv(r'C:\Users\jose_\Desktop\DA_Portfolio\Viz4\cvs\dim_tables\calendar.csv',
               usecols=['idx','week_day'])
hours = pd.read_csv(r'C:\Users\jose_\Desktop\DA_Portfolio\Viz4\cvs\dim_tables\hours.csv',
                   usecols=['idx','range_time'])
prov1 = pd.read_csv(r'C:\Users\jose_\Desktop\DA_Portfolio\Viz4\cvs\min_max_cap\full_trans1_2020.csv',
                   usecols=['prov_id','min_cap','max_cap'])
prov2 = pd.read_csv(r'C:\Users\jose_\Desktop\DA_Portfolio\Viz4\cvs\min_max_cap\full_trans2_2020.csv',
                    usecols=['prov_id','min_cap','max_cap'])
prov3 = pd.read_csv(r'C:\Users\jose_\Desktop\DA_Portfolio\Viz4\cvs\min_max_cap\full_trans3_2020.csv',
                        usecols=['prov_id','min_cap','max_cap'])
bus = pd.read_csv(r"C:\Users\jose_\Desktop\DA_Portfolio\Viz4\cvs\fact_tables\output_bus.csv")
metro = pd.read_csv(r"C:\Users\jose_\Desktop\DA_Portfolio\Viz4\cvs\fact_tables\output_metro.csv")
cablecar = pd.read_csv(r"C:\Users\jose_\Desktop\DA_Portfolio\Viz4\cvs\fact_tables\output_cablecar.csv")

#Filter Calendar to Weekdays
filter_cal = calendar[(calendar['week_day'] <6) & (calendar['idx'] >5)]

#Conditional Helper Column on Hour file
condition_hour = [
    (hours['range_time'] == 'S'),
    (hours['range_time'] == 'L'),
    (hours['range_time'] == 'M'),
    (hours['range_time'] == 'H')
    ]
values_hour = [0,0.1,0.3,0.5]
hours['percentage'] = np.select(condition_hour,values_hour)

#Merged Files
merged_1 = cablecar.merge(filter_cal,left_on='id_date',right_on='idx') #Change via files
merged_2 = merged_1.merge(hours,left_on='id_hours',right_on='idx')
merged_3 = merged_2.merge(prov3,left_on='id_province',right_on='prov_id')

#Conditional_Values on Merged file
cond_1_min = [
    (merged_3['range_time'] == 'S'),
    (merged_3['range_time'] == 'L'),
    (merged_3['range_time'] == 'M'),
    (merged_3['range_time'] == 'H')
    ]
val_1_min = [
    merged_3['min_cap'],
    merged_3['min_cap']-(merged_3['percentage']*merged_3['min_cap']),
    (merged_3['percentage']*merged_3['min_cap'])+merged_3['min_cap'],
    (merged_3['percentage']*merged_3['min_cap'])+merged_3['min_cap']
]
# Second Conditional_Values on Merged file
cond_2_max = [
    (merged_3['range_time'] == 'S'),
    (merged_3['range_time'] == 'L'),
    (merged_3['range_time'] == 'M'),
    (merged_3['range_time'] == 'H')
    ]
val_2_max = [
    merged_3['max_cap'],
    merged_3['max_cap']-(merged_3['percentage']*merged_3['max_cap']),
    (merged_3['percentage']*merged_3['max_cap'])+merged_3['max_cap'],
    (merged_3['percentage']*merged_3['max_cap'])+merged_3['max_cap']
]

merged_3['min_result'] = np.select(cond_1_min,val_1_min).astype(int)
merged_3['max_result'] = np.select(cond_2_max,val_2_max).astype(int)

# Generate random values 
merged_3['passangers'] = np.random.uniform(merged_3['min_result'],merged_3['max_result']).astype(int)

#Full File
completed_file = merged_3[['id_province','id_date', 'id_via', 'id_hours','passangers']]
#Capacity File
capacity_file = completed_file.groupby(['id_province','id_via']).agg(
    min_cap = ('passangers','min'),
    max_cap = ('passangers','max'))

# Prompt the user for file names
# file_name = input("Enter the name for the Full CSV file (e.g., 'output.csv'): ")
file_name1 = input("Enter the name for the Capacity CSV file (e.g., 'output.csv'): ")

# #Save file as CSV
# completed_file.to_csv(file_name, index=False)
# print(f"CSV file generated: {file_name}")
capacity_file.to_csv(file_name1, index=True)
print(f"CSV file generated: {file_name1}")
