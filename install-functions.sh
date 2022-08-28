function loading() {

echo "[*....]"
sleep 1
echo "[**...]"
sleep 1
echo "[***..]"
sleep 1
echo "[****.]"
sleep 1
echo "[*****]"
sleep 1

}

# Green text function with an argument
function green_text {
    # Just being fancy with some text
    echo -e "\033[0;32m $1 \033[0m"
}

# Red text function with an argument
function red_text {
    echo -e "\e[1;31m $1 \033[0m"
}

# Generates a random password with 6 characters, you can change to 6 to another number
# Advice is not to change since it's being shown at the end of the installation and you need it to login for the first time
function random_password {
    openssl rand -base64 6
} 
