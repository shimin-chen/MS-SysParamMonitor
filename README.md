## Objectives
- The goal of this tool is to provide a quick visualization of change of instrument parameters (temperature, humidity, current, etc.) over time.

## Prerequisite
- This tool requires instrument parameter log files as input. The mass spectrometer that this script is based on is a Thermo Scientific Q-Exactive Plus instrument. It may also work with other Thermo instrument that generate similar system parameter log file.

## Usage
1. Upload instrument log files 
   - this file is typically located in C:\Xcalibur\system\Exactive\log\ on your instrument PC
   - file names start with "InstrumentTemperature--", followed by yyyy-mm-dd). 
   - be careful not to select other file names. You can select one or more files. 
   - Check out [this file](https://github.com/shimin-chen/MS-SysParamMonitor/blob/main/InstrumentTemperature--2024-04-01.log) for an example of the log file
2. Select the parameters that you would like to visualize
3. (Optional) select a date range and/or dates to exclude from visualization. This option is useful for when you have a known reason for why instrument parameters change substantially (e.g. preventative maintenance)
4. Save the image or download the dataset if necessary

## Ways to use the tool

Check out this link if you need help with installing R and RStudio: https://rstudio-education.github.io/hopr/starting.html

### Method 1: run the Shiny app on your local machine
1. Download code: Code - Download ZIP
2. Open the R project in Rstudio
3. Click RunApp

### Method 2: deploy your own Shiny app on shinyapps.io
1. Download code: Code - Download ZIP
2. Unzip file and open the R project in Rstudio
3. Click "Publish the application or document" (the button next to RunApp)

### Method 3: try the Shiny app
You can try the Shiny app here: https://schen19.shinyapps.io/01_MS_Parameter_Monitoring/. However, it is not recommended to rely on this website because it is a free account and cannot handle too much traffic. It is better if you run the Shiny app locally or in your own deployment if you are a heavy user of this tool.

### Demo
Plotting ambient temperature
![Picture3](https://github.com/shimin-chen/MS-SysParamMonitor/assets/44071281/08c9e9ec-2200-4e8e-840d-471b171e4a3c)

### Troubleshooting
- Please make sure that you are uploading the correct log files. There are usually some other files that are *not* log files in the same folder. Make sure you don't accidentally include those files in your uploads.