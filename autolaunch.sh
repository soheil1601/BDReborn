#!/bin/bash
COUNTER=1
while(true) do
./beyond.sh
curl "https://api.telegram.org/bot367368593:AAF4di-jB6yrdBxbYYEbVxiRY3R0KywrT_4/sendmessage" -F "chat_id=308444837" -F "text=#NEWCRASH-#TeleBeyond-Reloaded-${COUNTER}-times"
let COUNTER=COUNTER+1 
done