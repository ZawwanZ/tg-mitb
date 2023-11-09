#!/data/data/com.termux/files/usr/bin/bash
BANNER() {
  echo -e "\033[1;33m   __  ___ ____ ______ ___ \033[0m"
  echo -e "\033[1;33m  /  |/  //  _//_  __// _ \ \033[0m"
  echo -e "\033[1;33m / /|_/ /_/ /   / /  / _  |\033[0m"
  echo -e "\033[1;33m/_/  /_//___/  /_/  /____/ \033[0m"

  echo -e "\033[1;34mMAN IN THE BOT\033[0m"
  echo -e  "\e[1;31m SINGLE TARGET MESSAGE SENDER \e[0m"
  echo -e "\033[1;32mAuthor:\033[0m zawwanz and warren"
  echo -e "\033[1;32mTelegram:\033[0m @sanwanazaw"
  echo -e "\033[1;32mVersion:\033[0m 1.0"
}

# Call the function
BANNER

BOT_API_TOKEN="bot api" #replace
TMP_DIR="/data/data/com.termux/files/usr/tmp"
read -p "Enter your telegram-user id :"  CHAT_ID

function send_message() {
  local text="$1"
  curl -s -X POST "https://api.telegram.org/bot$BOT_API_TOKEN/sendMessage" \
    -d "chat_id=$CHAT_ID" \
    -d "text=$text" | jq
    echo -e "===================================================================="
}

function send_file() {
  local file_path="$1"
  local caption="$2"
  
  curl -s -F "chat_id=$CHAT_ID" -F "document=@$file_path" -F "caption=$caption" -F "parse_mode=Markdown" -F "disable_notification=true" -F "disable_web_page_preview=true" -F "allow_sending_without_reply=true" \
    "https://api.telegram.org/bot$BOT_API_TOKEN/sendDocument" | jq 
    echo -e "===================================================================="
    
}

while true; do
  echo "Select an action:"
  echo "1. Send a message"
  echo "2. Capture and send a photo"
  echo "3. Record and send audio"
  echo "4. Send a file"
  echo "5. Exit"
  read -p "Enter the number of the action (or 5 to exit): " choice

  case $choice in
    1)
      read -p "Enter your message: " message
      send_message "$message"
      ;;
    2)
      # Capture a photo using the camera
      termux-camera-photo -c 1 "$TMP_DIR/captured_photo.jpg"
      send_file "$TMP_DIR/captured_photo.jpg" "Captured photo" "image/jpeg"
      ;;
    3)
  # Record audio using the microphone
      read -p "Enter the audio duration in seconds: " audio_duration
      termux-microphone-record -f "$TMP_DIR/recorded_audio.wav" -l "$audio_duration"
      send_file "$TMP_DIR/recorded_audio.wav" "Recorded audio" "audio/wav"
      ;;


    4)
      #file
      read -p "Enter the path to a file: " file_path
      read -p "Enter a caption: " caption

      send_file "$file_path" "$caption"
      ;;
    5)
      echo "Exiting the script. Goodbye!"
      exit 0
      ;;
    *)
      echo "Invalid choice. Please enter a valid option."
      ;;
  esac
done
