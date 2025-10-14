# Import and clean treatment chemistry data
EVR 628 Assignment 2 - Data Wrangling.
This script analyzes treatment chemistries for a coral larvae settlement experiment from September 2025. It imports the raw bottle data from the Methrom
robotic alkalinity titrator and joins it to coral and sample metadata.

## Respository contents

The repository contains three main folders:

data:

- data/raw contains .csv files for raw chemistry data and coral/sample metadata

- data/processed contains the cleaned up version of my data

scripts:

- scripts/01_processing contains a single script that reads the raw data, cleans it up, and exports processed data.


## About the data

### `data/processed/all_data.rds` contains 66 rows and 11 columns:

- `date` - Character - date sample was taken
- `sample_num` - Character -bottle identifier
- `vessel` - Character - coral vessel the sample was taken from
- `p_h_pico` - Numeric - pH recorded at time of sample by pico probe
- `temp` - Numeric - temperature at sample time
- `treatment` - Character - alkalinity treatment of vessel (one of four)
               \n - Treatments:
               \n - a ~ 2600 umol/kg
               \n - b ~ 2900 umol/kg
               \n - c ~ 3200 umol/kg
               \n - d- ~ 3570 umol/kg
                  
- `content` - Character - Vessel either contains baby corals or is a blank
- `species` - Character - Coral species (pstr or ofav)
- `salinity` - Numeric - Salinity in ppt of sample
- `ta_av` - Numeric - Mean total alkalinity of the two sample replicates in umol per kilogram
- `ta_sd` - Numeric - standard deviation of the two sample replicates
