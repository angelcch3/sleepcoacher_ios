import csv
import time 
import datetime
import os
import re

def processMovements(movements):
	if sum([float(m[1]) for m in movements]) <= 0.1: # something wrong with the accelerometer
		return None, None

	#print ','.join([str(i[1]) for i in movements])

	# assumes hhmmss2 is earlier than hhmmss1
	def hourSubtract(hhmmss1, hhmmss2): # returns seconds
		hh1, mm1, ss1 = [int(num) for num in hhmmss1.split(':')]
		hh2, mm2, ss2 = [int(num) for num in hhmmss2.split(':')]
		if hh1 < hh2:
			hh1 += 24
		return (hh1 * 60 * 60 + mm1 * 60 + ss1) - (hh2 * 60 * 60 + mm2 * 60 + ss2)

	awakenings = []
	onsetlatency = None
	lastActivity = movements[0][0] + ':00'
	isAwake = True
	lasthhmm = None
	lastss = 0
	for m in movements:
		movementLevel = m[1]
		if m[0] == lasthhmm:
			lastss += 10
			# assert(lastss < 60) # assert fails due to data polling uneveness
			if lastss > 59:
				lastss = 59
			hhmmss = lasthhmm + ':' + str(lastss)
		else:
			hhmmss = m[0] + ':00'
			lastss = 0
		lasthhmm = m[0]
		if movementLevel >= 0.98:
			if hourSubtract(hhmmss, lastActivity) < 2 * 60:
				if not isAwake:
					awakenings.append(lastActivity)
				isAwake = True
			lastActivity = hhmmss
		else:
			continuousInactivity = hourSubtract(hhmmss, lastActivity)
			if continuousInactivity >= 2 * 60:
				isAwake = False
			if continuousInactivity >= 20 * 60 and onsetlatency is None:
				onsetlatency = hourSubtract(lastActivity, movements[0][0] + ':00') # in seconds
				assert(onsetlatency >= 0)

	return onsetlatency, awakenings



if not os.path.exists('sleep.csv'):
	with open ('sleep.csv', 'wb') as csvfile4:
			spamwriter = csv.writer(csvfile4, delimiter=',')
			spamwriter.writerow(['start_time_str', 'end_time_str', 'timezone', 'location', 'rating', 'noisiness', 'deep_sleep', 'cycles', 'alarm_str', 'comment', 'alarm_count'])

if not os.path.exists('simple.csv'):
	with open ('simple.csv', 'wb') as csvfile5:
			spamwriter = csv.writer(csvfile5, delimiter=',')
			spamwriter.writerow(['date', 'rating', 'hoursslept', 'sol', 'awakenings', 'aph', 'fromTime', 'wakeTime'])


for line in csv.reader(open('combined.csv'), delimiter = ';'):
	with open('sensors.csv', 'a') as csvfile1:
		for field in line:
			if "decibelLevel" in field:
	 			spamwriter1 = csv.writer(csvfile1, delimiter=',',escapechar=' ',quoting=csv.QUOTE_NONE )
	 			epoch_timestamp = float(field.split(',')[0].split(":")[1].strip())/float(1000)
	 			timestamp = str(datetime.datetime.fromtimestamp(epoch_timestamp))
	 			timestamp = timestamp.split()[0]+'T'+timestamp.split()[1].split('.')[0]+'Z'
	 			noise_data = field.split(',')[1].split(":")[1]
	 			spamwriter1.writerow([timestamp, 'noise',noise_data])
	 		if 'acceleormeter' in field:
	 			spamwriter1 = csv.writer(csvfile1, delimiter=',',escapechar=' ',quoting=csv.QUOTE_NONE )
	 			epoch_timestamp = float(field.split(',')[0].split(":")[1].strip())/float(1000)
	 			timestamp = str(datetime.datetime.fromtimestamp(epoch_timestamp))
	 			timestamp = timestamp.split()[0]+'T'+timestamp.split()[1].split('.')[0]+'Z'
	 			movement_data = field.split(',')[1].split(":")[1]
	 			spamwriter1.writerow([timestamp, 'movement', movement_data])

			
	with open('sleep.csv', 'a') as csvfile2:	
		for field in line:	
			if 'User' in field:
				spamwriter1 = csv.writer(csvfile2, delimiter=',',escapechar=' ',quoting=csv.QUOTE_NONE )	
				all_fields = field.split('&')
				for item in all_fields:
					if 'End' in item:
						end_epoch =  float(item.split('=')[1].split(',')[0])/float(1000)
			 			end_timestamp = str(datetime.datetime.fromtimestamp(end_epoch))
			 			end_timestamp = end_timestamp.split()[0]+'T'+end_timestamp.split()[1].split('.')[0]+'Z'

			 		if 'Start' in item:
			 			start_epoch =  float(item.split('=')[1])/float(1000)
			 			start_timestamp = str(datetime.datetime.fromtimestamp(start_epoch))
			 			start_timestamp = start_timestamp.split()[0]+'T'+start_timestamp.split()[1].split('.')[0]+'Z'

			 		if 'Rating' in item:
			 			rating = item.split(':')[1].split(',')[0]

			 		if 'Tags' in item:
			 			comment = item.split('Tags')[1].split(':')[1]
			 			comment = re.sub('%23','#',comment)
			 			comment = re.sub(',',' ',comment)
			 			comment = re.sub('#',' #',comment)

			 		timezone = 'America/New_York'
			 		location = '9adb2f9'
			 		noisiness = 0.5
			 		deep_sleep = 0.2
			 		cycles = 3
			 		alarm_str = ''
			 		alarm_count = 0
				spamwriter1.writerow([start_timestamp,end_timestamp,timezone,location,rating, noisiness, deep_sleep, cycles,alarm_str,comment, alarm_count])


	with open('simple.csv', 'a') as csvfile3:	
		for field in line:	
			if 'User' in field:
				spamwriter3 = csv.writer(csvfile3, delimiter=',',escapechar=' ',quoting=csv.QUOTE_NONE )	
				all_fields = field.split('&')
				for item in all_fields:
					if 'End' in item:
						original_end_epoch = int(item.split('=')[1].split(',')[0])
						end_epoch =  float(item.split('=')[1].split(',')[0])/float(1000)
			 			end_timestamp = str(datetime.datetime.fromtimestamp(end_epoch))
			 			original_end_timestamp = end_timestamp.split('.')[0]
			 			old_end_date = end_timestamp.split()[0]
			 			end_date = old_end_date.split('-')[2]+"."+old_end_date.split('-')[1]+"."+old_end_date.split('-')[0]
			 			wakeTime = end_date + " " + end_timestamp.split()[1].split('.')[0].split(':')[0] + ":" + end_timestamp.split()[1].split('.')[0].split(':')[1]
			 			end_timestamp = end_timestamp.split()[0]+'T'+end_timestamp.split()[1].split('.')[0]+'Z'

			 		if 'Start' in item:
			 			original_start_epoch = int(item.split('=')[1])
			 			start_epoch =  float(item.split('=')[1])/float(1000)
			 			start_timestamp = str(datetime.datetime.fromtimestamp(start_epoch))
			 			original_start_timestamp = start_timestamp.split('.')[0]

			 			old_date = start_timestamp.split()[0]
			 			date = old_date.split('-')[2]+"."+old_date.split('-')[1]+"."+old_date.split('-')[0]
			 			fromTime = start_timestamp.split()[1].split('.')[0].split(':')[0] + ":" + start_timestamp.split()[1].split('.')[0].split(':')[1]
			 			start_timestamp = start_timestamp.split()[0]+'T'+start_timestamp.split()[1].split('.')[0]+'Z'

			 		if 'Rating' in item:
			 			rating = item.split(':')[1].split(',')[0]

			 	movements = []
			 	for fields in csv.reader(open('sensors.csv'), delimiter=',', quotechar='"'):
					if 'movement' in fields:
						timestamp = fields[0].split('T')[1].split('Z')[0]
						timestamp = timestamp.split(':')[0]+":" + timestamp.split(':')[1]
						movements.append((timestamp,fields[2]))

			 	onsetlatency, awakenings = processMovements(movements)
				if awakenings is None:
					numawakenings = None
				else:
					numawakenings = len(awakenings)

			 	d1 = datetime.datetime.strptime(original_start_timestamp, '%Y-%m-%d %H:%M:%S')
				d2 = datetime.datetime.strptime(original_end_timestamp, '%Y-%m-%d %H:%M:%S')
			 	hoursslept = (d2 - d1).total_seconds()/3600

			 	### awakenings per hour ####
				if awakenings is not None:
					try:
						awakeningsPerHour = float(numawakenings)/float(hoursslept)
					except:
						awakeningsPerHour = float('Inf')
				else:
					awakeningsPerHour = 'none'

				spamwriter3.writerow([date,rating, hoursslept, onsetlatency, awakenings, awakeningsPerHour, fromTime, wakeTime])


# # # May 7 # # #
# QUESITON - not sure if this is the right timezone. Currently, it gives me the correct time - the epoch says it happened at 3pm, and it really did happen at 3pm. BUT on the files from sleep as android, when it says something happened at 03:27am on March 18, it actually happened at 11:27pm on March 17 for that user. So, should I change this to always show a time that's 4 hours ahead to mimic the orignal data as much as possible?

# QUESTION - write now I'm not getting the timezone for that user anyway. I think this is using my current system's timezone. SO MAKE SURE YOU GET THE TIME ZONE AS WELL.

# FIXED - start time and end time come in different fields. I can try to match them up, but if there is ever a discrepency, they might get completely off. what's a better way? NOW, at the end we are not only transfering user and end timestamp, but also the start timestamp.

# # # May 16 # # ##
# sleep.csv now contains the correct format for rating and comment! the only things that are subs are cycles, deep__sleep, noisiness, alarm_str, and alarm_count because we don't have those values yet. 
# sensors.csv is fine

# now onto simple data files!! 
# date,rating, hoursslept, sol, #awakenings, aph, fromTime, wakeTime
# we have date, rating, hoursslept can be calculated, fromtime and waketime. 
# need to calculate sol, #awakenings, and #aph

# wakeTime in this format looks like this "16.05.2016  10:37", but waketime in the original document is like this "13. 03. 2016 8:37". Not sure if the spaces after the dots are essential, so leaving it like this for now. 

# hoursslept - DONE :) but check if the conversion works for actual hours.. it works for seconds :D 

# onsetlatency and awakenings - DONE (i think, need to test on actual data!!)