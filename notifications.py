import requests

# a token for each of us 
nedi = "flcH1r9Ft2g:APA91bFqDLVr8WwaO8A_otm3zoM_W5OFGguXRg83iJTzd9nFns6rFJE8NWvfT8GH49uktghs7xnmsnc1opFD9l_pNG0thtrhUavMONvzzpyiplU0TgzNGS8lZwJ3Q2G9YE99_0aevXqC"
memo = "dig0NXdvJlk:APA91bE8cm1nO4Z1kuckxpIq0DD54YcaaFjA9sOplfXoLm21bDkk6_77jwabMighdRSU6YuuYsWLeHUOJA5qMqNQqiChA7YIO2MIoQLlVC34wEYXFhW9ngCBjZG89DeEkw8eBfC9QmK4"
url     = 'https://fcm.googleapis.com/fcm/send'

# server key from https://console.firebase.google.com/project/sleepcoacher/settings/cloudmessaging?authuser=2
header = {'Authorization':'key=AAAAnYhGamg:APA91bGqp0Rmj4WsfTMU1izCP_BymJbEdw5GQjjfNe8nksKVNakHx9AX3ptP6CpnZxs9wWL51GRfqPzcEjGFAPRWRnpgpM9EzfFV7vkf3xY1l_htImQxngl3vJzdpQ6ADMFgVD3MnROK' }

# this is where I enter the "body" of the notification!! and who it's going to. 
res = requests.post(url, json={'notification':{  
  "title":"SleepCoacher",
  "body":"sending to both of us?",
  "content_available": "true"
},"registration_ids":[nedi,memo]}, headers=header)

# for testing purposes, i'm priting the response text and code
print res

if __name__=='__main__':
    print res.text


# api_key = 'AIzaSyA2cGRXGljWBTv1PAiwj-cc32-lm-yIvJ0'

# header = 'Authorization: key='+api_key
# # data = '{"registration_ids":["ABC"]}'

# payload =  {"registration_ids":[memo]}