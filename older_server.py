#input: none, just run the app with "sudo python server_decrypt.py"
# output: a new file every time a user presses the stop button AND a combined.csv which contains all the data for this user so far. Each new line in combined.csv is a new press of the stop button. Thus, we have 1 new file for each new recoding, and then in combined we have all of them combined, with each recording on a new line. 

import SimpleHTTPServer
import SocketServer
import logging
import cgi
import errno
import os
from os import curdir
from os.path import join as pjoin
import re
import json

from Crypto import Random
from Crypto.Cipher import AES
import base64
import hashlib
import binascii # for bytes to hex

import sys

import zlib

BLOCK_SIZE=32
PORT = 443 #changed port to 443 so that we can host the sleepcoacher website on port 80
FLAGS = os.O_CREAT | os.O_EXCL | os.O_WRONLY



def decrypt(encrypted, passphrase):
    IV = ''.join(chr(x) for x in [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
    aes = AES.new(passphrase, AES.MODE_CBC, IV)
    # aes is a new instance of the AES where:
    # passphrase: it's actually the key, so the hashed passphrase, which we pass already hashed
    # CBC is the mode used by the android version of sleepcoacher, so we are using that as well
    # IV : is also set by default at 16 empty bytes by the android version of sleepcoacher, so we are setting it to that
  
    # next, in order to decrypt, we must first DECODE the encrypted dat with "base64.b64decode", and only THEN we can use aes.decrypt
    # (btw, to get the size of anything in bytes, we are using sys.getsizeof(base64.b64decode(encrypted))
    # which gives us 37 bytes more than it actually is. 
    # aes needs the decoded data to be in bytes divisible by 16
    # # print "DECODED64", base64.b64decode(encrypted)      
    # # print "SIZE DECODED64", sys.getsizeof(base64.b64decode(encrypted))
    return aes.decrypt(base64.b64decode(encrypted))
    	

class ServerHandler(SimpleHTTPServer.SimpleHTTPRequestHandler):
    store_path = pjoin(curdir, 'all_data.csv')
    def do_GET(self):
        # # logging.error(self.headers)
        # # SimpleHTTPServer.SimpleHTTPRequestHandler.do_GET(self)
        # # print "in get request"
        # # print self.path #self.path here is just "/"
        # # if self.path ==  '/storeNov19.txt':
        # #     print "YES PATH"
        with open(self.store_path, 'r') as fh:
            # # print "in write to file"
            
            read_data = fh.read()
            # # print read_data
            self.send_response(200)
        fh.close()
                # # self.send_hearder('Content-type', 'text/json')
                # # self.end_headers()
                # # self.wfile.write(fh.read().encode())

    def do_POST(self):
        logging.error(self.headers)
        # # print "IN POST REQUEST"
        # # print self.rfile
        
        data_string = self.rfile.read(int(self.headers['Content-Length']))
	# # data_string = self.headers['Content-Length']
	# # print data_string	
	# # print "DECRYPTED"


	if data_string[0] != "%":
		print "Android, so decrypt and decompress"
		data_string_new = data_string.split(":")[1].split("\"")[1]	
		# # print "JSON DATA", data_string_new
		# get everything but the last character
		output_1 = data_string_new[:-1]
	
		# once the data is encrypted, it has a lot of extra backslashes for escaping characters, 
		# so we get rid of them before we can decrypt (since they add extra bytes and aes would be confused) 
		output = output_1.replace('\\\\','')
	 	#print "OUTPUT"
		#print output
		#print
		# we need to hash the password with sha256 to make it into a key before passing it to the decrypt function
		password = "BROWN_HCI_SLEEP_COACHERR"
		key = hashlib.sha256(password).digest()
		decrypted = decrypt(output, key)
		# now "decrypted" is the completely decrypted output that looks exactly like the original raw data
		#print "decrypted"
		#print "END OF DECRYPTIONS"
	
		# next, we have to decompress the decrypted data. none of the things we tried were working, so we asked on stackoverflow, and someone helped us solve it by making sure the data is base64 encode on the java side, and then decoding it with base64 on this side. 

		# --- STUFF BETWEEN HERE AND NEXT "STUFF" DIDN'T WORK --- 
		#print "COMPRESSED IN HEX"
		#hexed = binascii.hexlify(bytearray(decrypted)) # this turns byte array to string
		#data_string = zlib.decompress(decrypted,-zlib.MAX_WBITS)
		#data_string = zlib.decompress(decrypted, zlib.MAX_WBITS|32)
		#zlib.decompress(decrypted, -zlib.MAX_WBITS)
		#data_string = zlib.decompressobj(decrypted,15+32)
		#data_string = inflate(decrypted)

		#deflated_bytes= base64.decodestring(decrypted)
		#print "DECODED"
		#print hexed
		# ----- STUFF BETWEEN HERE AND PREVIOUS "STUFF" DIDN'T WORK --- 

		# this worked - we just decode the string with base64, and then we decompress it
		base64_binary = decrypted 
		deflate_bytes=base64.decodestring(base64_binary)

		data_string = zlib.decompress(deflate_bytes)
	
		#data_string = zlib.decompress(decrypted, zlib.MAX_WBITS|16)
	
		print "DECOMPRESSED"
		print data_string
	else:
		print "iOS so no decrypt, no decompress"
		
	# the code below gets executed no matter if it's ios or android. 
	# data_string = decrypted # that's only if didn't use compressio/decompressio
	items = data_string.split('&')
	print "items", items
	for item in items:
		if "User" in item: # find the username and create a folder for it if it doesn't exist
			details = item.split('=')
			username = details[1]
			#print "username", username
			if not os.path.exists(username):
				os.makedirs(username)
		elif "Date" in item: # find the start date and create a csv for it if it doesn't exist
			details = item.split('=')
			date = details[1]
			date = re.sub('%2C','',date)
			dateName = date + '.csv'
			#print "Item", item
			#print "details", details
			#print "details[1]", details[1]
			#print "dateName", dateName
			#print "DATES", date
	
	# use regular expressions to substitute back to actual characters	
	data_string = re.sub('%3A',':',data_string)
	data_string = re.sub('%20','',data_string)
	data_string = re.sub('%2C',',',data_string)
	data_string = re.sub('%3D','=',data_string)
	data_string = re.sub('%0A','\n',data_string)
	data_string = re.sub('%3B', ';', data_string)

	# create path name for combined.csv for each user
	combined_path = pjoin(username, 'combined.csv')
	combined_file = combined_path

	# if the combined.csv for this user doesn't exist, create it
	# otherwise, just open it and start writing to it
	if not os.path.exists(combined_path):
		combined_file = os.open(combined_path, FLAGS)

	try:
		filepath = pjoin(username,dateName)
		#if os.path.exists(filepath):
		#	print "EXITS, APPENDING", filepath
		#else:
		#	print "first time", filepath				
        	#	file_handle = os.open(filepath, FLAGS)
	except OSError as e:
		if e.errno == errno.EEXIST: #changed it from EEXISTS
			pass
		else: 
			raise
	else: 
		#if os.path.exists(filepath):
		#	print "EXITS, APPENDING", filepath
		#else:
		#	print "first time", filepath				
        	#	file_handle = os.open(filepath, FLAGS)

		# write the data to a new csv for this tracking moment		
		#with os.fdopen(file_handle, 'a') as file_obj:
		#	file_obj.write(data_string)
		with open(filepath, "a") as myfile:
    			myfile.write(data_string)
		
		# write the data to the combined.csv file
		with open(combined_path, 'a') as file_ob:
			#print "DATASTRING", data_string
			#print "EXTRACTED TYPE", type(data_string)
			#print "FIRST THING", data_string[0] 
			file_ob.write(data_string)

	
	with open(self.store_path, 'a') as fh:
	    fh.write(data_string)	
        self.send_response(200)
 	self.wfile.write('\n')
        # # print data_string

Handler = ServerHandler

httpd = SocketServer.TCPServer(("", PORT), Handler)

print "serving at port", PORT
httpd.serve_forever()