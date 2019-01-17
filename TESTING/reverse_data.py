# input: the original combined csv (which has the latest data on the bottom)
# output: a reversed csv which has the lastest data on the top. 
# for now it must be run from the same folder as combined.csv
import os
import csv

try:
    os.remove('reversed.csv')
except OSError:
    pass

with open('combined.csv', 'r') as textfile:
    for row in reversed(list(csv.reader(textfile))):
    	with open('reversed.csv', 'a') as reversed_file:
    		reversed_row = ', '.join(row)
    		print reversed_row
    		print type(reversed_row)
    		reversed_file.write(reversed_row)
       		# print ', '.join(row)


n