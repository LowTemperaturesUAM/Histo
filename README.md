# Histo
Makes histograms out of current vs distance curves. Provides currant as well as conductance histograms
The program handles blq files that include two column data on a binary format.
Input files consist of blocks of data.
Each block has a header with information about the acquisition and a two-column vector holding the data.
Each data file holds 2048, 1024, ... lines of data.
The program takes the second column of each block of data and counts the instances for the appearance of a given value.
This provides the histogran, plotted in the main panel.
The program needs xyygraph component.
Point Nr choses the bin number.
Begin and End count give the maximum and minimum current to count.
Top distance provides the maximum value in the x-axis where it stops counting.
The memo panel includes the headers of the number of files given in Show Files.
There is a maximum amouunt of data that is counted, which is provided in the text box after "stop at".
Button count length serves to count the length of a file.
File is selected in "select blq".
Start serves to start the program.
Histograms can be made on current or on conductance. This takes the first or the second column of the file.
Copy graph copies the data on the graph to paste in anohter program.
There are missing items in this description. These will be added later.
