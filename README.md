## Objectives

- The goal of this tool is to provide a quick visualization of change of instrument parameters (temperature, humidity, current, etc.) over time.

## Prerequisite: 
- This tool requires instrument parameter log files as input. The mass spectrometer that this script is based on is a Thermo Scientific Q-Exactive Plus instrument. It may also work with other Thermo instrument that generate similar system parameter log file.

## Usage
1. Upload instrument log files (typically located in C:\Xcalibur\system\Exactive\log\ on your instrument PC, file names begin with "InstrumentTemperature--", followed by yyyy-mm-dd). Be careful not to select other file names. You can select one or more files.
2. Select the parameters that you would like to visualize
3. (Optional) select a date range and/or dates to exclude from visualization. This option is useful for when you have a known reason for why instrument parameters change substantially (e.g. preventative maintainence)
4. Save the image or download the dataset if necessary

## Ways to use the tool
### Method 1: run the Shiny app on your local machine
1. Download code: Code - Download ZIP
2. Open the R project in Rstudio
3. Click RunApp

### Method 2: deploy your own Shiny app on shinyapps.io
1. Download code: Code - Download ZIP
2. Unzip file and open the R project in Rstudio
3. Click Publish the application or document (the button next to RunApp)

### Method 3: try the Shiny app
You can try the Shiny app here: https://schen19.shinyapps.io/01_MS_Parameter_Monitoring/. However, it is not recommended to rely on this. This is a free account and cannot handle too much traffic. It is better if you run the Shiny app locally or in your own deployment if you are a heavy user of this tool.

### Demo
Plotting ambient temperature

