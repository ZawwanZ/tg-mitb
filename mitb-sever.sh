#!/bin/bash
BANNER() {
  echo -e "\033[1;33m   __  ___ ____ ______ ___ \033[0m"
  echo -e "\033[1;33m  /  |/  //  _//_  __// _ \ \033[0m"
  echo -e "\033[1;33m / /|_/ /_/ /   / /  / _  |\033[0m"
  echo -e "\033[1;33m/_/  /_//___/  /_/  /____/ \033[0m"

  echo -e "\033[1;34mMAN IN THE BOT\033[0m"
  echo -e  "\e[1;31m BOT-SEVER \e[0m"
  echo -e "\033[1;32mAuthor:\033[0m zawwanz"
  echo -e "\033[1;32mTelegram:\033[0m @sanwanazaw"
  echo -e "\033[1;32mVersion:\033[0m 1.0"
}

# Call the function
BANNER




BOT_API_TOKEN="Bot api" #replace you can get it from ``https://t.me/BotFather``
function send_message() {
  local chat_id="$1"
  local text="$2"
  curl -s -X POST "https://api.telegram.org/bot$BOT_API_TOKEN/sendMessage" -d "chat_id=$chat_id" -d "text=$text" | jq >> /dev/null
}

NO_FORMAT="\033[0m"
F_DIM="\033[2m"
F_INVERT="\033[7m"
C_GREY0="\033[38;5;16m"
C_GREY66="\033[48;5;248m"


function process_file_message() {
  local chat_id="$1"
  local file_id="$2"
 nikname=$(echo "$updates" | jq -r '.result[].message.from.first_name')
 lastname=$(echo "$updates" | jq -r '.result[].message.from.last_name')
 msgid=$(echo "$updates" |jq -r '.result[].message.message_id')
 usn=$(echo "$updates" | jq -r '.result[0].message.from.username')
 caption=$(echo "$updates" | jq -r '.result[0].message.caption')
  # echo $updates | jq
 echo -e "USER-NAME:""\e[34m @$usn \e[0m"
 echo -e "NIKNAME:" "\e[34;7m $nikname $lastname \e[0m"
 echo -e "File ID :" "\e[36;1m $file_id \e[0m"
 echo -e "MESSAGE ID :""${F_DIM}${F_INVERT}${C_GREY0}${C_GREY66}$msgid${NO_FORMAT}"
 echo -e "USER-ID :" "${F_DIM}${F_INVERT}${C_GREY0}${C_GREY66}$chat_id${NO_FORMAT}"
 echo -e "MESSAGE :" "\e[34;1m $message \e[0m"
 echo -e "CAPTION :" "\e[34;1m $caption \e[0m"

  # Retrieve file information
  file_info=$(curl -s "https://api.telegram.org/bot$BOT_API_TOKEN/getFile?file_id=$file_id")
  file_path=$(echo "$file_info" | jq -r '.result.file_path')
  file_url="https://api.telegram.org/file/bot$BOT_API_TOKEN/$file_path"
  
 
  echo -e "FILE:" "\e[31m$file_url \e[0m"
  echo -e "======================================================================================================================"
}


function check_for_updates() {
  local offset=0
  while true; do
    updates=$(curl -s "https://api.telegram.org/bot$BOT_API_TOKEN/getUpdates?offset=$((offset+1))&timeout=30")
    


    if [[ $(echo "$updates" | jq '.result | length') -gt 0 ]]; then
      message=$(echo "$updates" | jq -r '.result[0].message.text')
      chat_id=$(echo "$updates" | jq -r '.result[0].message.chat.id')
      file_id=$(echo "$updates" | jq -r '.result[0].message.document.file_id')
      message_id=$(echo "$updates" | jq -r '.result[0].update_id')
       if [[ $file_id == null ]]; then
          file_id=$(echo "$updates" | jq -r '.result[0].message.photo[-1].file_id')
          if [[ $file_id == null ]]; then
            file_id=$(echo "$updates" | jq -r '.result[0].message.voice.file_id')
          fi
          
      fi

      if [[ ! -z "$message" ]]; then
        read -p "User ($chat_id) sent a message: '$message'. Enter your reply: " reply
        send_message "$chat_id" "$reply"
      fi
      
      if [[ ! -z "$file_id" ]]; then
        process_file_message "$chat_id" "$file_id"
      fi

      offset="$message_id"
    fi
    
  done
}


check_for_updates

