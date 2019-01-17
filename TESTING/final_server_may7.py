# input: none, just run the app
# output: a new file every time a user presses the stop button AND a combined.csv which contains all the data for this user so far. Each new line in combined.csv is a new press of the stop button. Thus, we have 1 new file for each new recoding, and then in combined we ahve all of them combined, with each recording on a new line. 

import SimpleHTTPServer
import SocketServer
import logging
import cgi
import errno
import os
from os import curdir
from os.path import join as pjoin
import re

PORT = 80
FLAGS = os.O_CREAT | os.O_EXCL | os.O_WRONLY

class ServerHandler(SimpleHTTPServer.SimpleHTTPRequestHandler):
    store_path = pjoin(curdir, 'all_data.csv')
    def do_GET(self):
        # logging.error(self.headers)
        # SimpleHTTPServer.SimpleHTTPRequestHandler.do_GET(self)
        print "in get request"
        # print self.path #self.path here is just "/"
        # if self.path ==  '/storeNov19.txt':
        #     print "YES PATH"
        with open(self.store_path, 'r') as fh:
            print "in write to file"
            
            read_data = fh.read()
            print read_data
            self.send_response(200)
        fh.close()
                # self.send_hearder('Content-type', 'text/json')
                # self.end_headers()
                # self.wfile.write(fh.read().encode())

    def do_POST(self):
        logging.error(self.headers)
        print "IN POST REQUEST"
        print self.rfile
        
        data_string = self.rfile.read(int(self.headers['Content-Length']))
	print data_string	
	items = data_string.split('&')
	for item in items:
		if "User" in item:
			details = item.split('=')
			username = details[1]
			print "username", username
			if not os.path.exists(username):
				os.makedirs(username)
		elif "Date" in item:
			details = item.split('=')
			date = details[1]
			date = re.sub('%2C','',date)
			dateName = date + '.csv'
	data_string = re.sub('%3A',':',data_string)
	data_string = re.sub('%20','',data_string)
	data_string = re.sub('%2C',',',data_string)
	data_string = re.sub('%3D','=',data_string)
	data_string = re.sub('%0A','\n',data_string)
	combined_path = pjoin(username, 'combined.csv')
	combined_file = combined_path
	if not os.path.exists(combined_path):
		combined_file = os.open(combined_path, FLAGS)

	try:
		filepath = pjoin(username,dateName)			
        	file_handle = os.open(filepath, FLAGS)
	except OSError as e:
		if e.errno == errno.EEXISTS:
			pass
		else: 
			raise
	else: 
		with os.fdopen(file_handle, 'a') as file_obj:
			#file_obj.write(data_string.decode())
			file_obj.write(data_string)
		
		with open(combined_path, 'a') as file_ob:
			file_ob.write(data_string)

	with open(self.store_path, 'a') as fh:
            #fh.write(data_string.decode())
	    fh.write(data_string)	
        self.send_response(200)
 	# self.wfile.write('done')
        print data_string

Handler = ServerHandler

httpd = SocketServer.TCPServer(("", PORT), Handler)

print "serving at port", PORT
httpd.serve_forever()