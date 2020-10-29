# MATLAB post processing
MATLAB calls STAR-CCM+ in batch to get and plot reports (e.g. aero forces and coefficients) vs a sweep variable (e.g. angle of attack) from a list of sim files.

## Detailed description
Calls STAR-CCM+ in batch with a macro to get and plot the desired reports
versus an independent variable. Useful to list and plot data from a
design sweep like an airfoil investigated at several angles of attack,
where each sim file is an angle of attack. Works with Microsoft Windows.

It is assumed that the sim file name has the numeric independent variable
in the last characters. MATLAB will try to get the 'prefix' of this file
name, i.e. the root of the name without the independent variable value.
For instance:

`mysimfile_alpha0.0.sim  -->  prefix = mysimfile_alpha`

or

`mysimfile_alpha0.sim  -->  prefix = mysimfile_alpha`

This script will work well with the last characters as floating point
digits, even with zero decimal positions. The script will ask the user to
check if the prefix has been correctly captured, otherwise it asks the
user to write the prefix.

Then the script will ask the user to choose the sim files from which 
extract all the reports with the JAVA macro `Report_to_csv.java`. The sim
files are all those with the same prefix previously defined, in the
folder initially selected, so that it should be easy to get the files of
interest even if the folder is populated with many and different file
types.

Finally, the script asks the user which report to plot versus the
independent variable, from a list of all extracted reports. Sparse
selection (e.g. non-contiguous angles of attack) is also permitted.
