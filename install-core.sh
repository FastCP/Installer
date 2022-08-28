#!/bin/bash

# Starting the installation

echo "888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888"
echo "888888888888888888888888888888888888 Starting the FastCP+ installation 8888888888888888888888888888888888888"
echo "888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888"
echo ""
echo "8 8888888888       .8.            d888888o.   8888888 8888888888 ,o888888o.    8 888888888o              "
echo "8 8888            .888.         .\`8888:' \88.       8 8888      8888     \`88.  8 8888    \`88.         "
echo "8 8888           :88888.        8.\`8888.    Y8      8 8888   ,8 8888       \`8. 8 8888     \`88       8 88"
echo "8 8888          . \`88888.       \`8.\`8888.           8 8888   88 8888           8 8888     ,88       8 88"
echo "8 888888888888 .8. \`88888.       \`8.\`8888.          8 8888   88 8888           8 8888.   ,88'  88 8888888888"
echo "8 8888        .8\`8. \`88888.       \`8.\`8888.         8 8888   88 8888           8 888888888P'   88 8888888888"
echo "8 8888       .8' \`8. \`88888.       \`8.\`8888.        8 8888   88 8888           8 8888               88 8"
echo "8 8888      .8'   \`8. \`88888.  8b   \`8.\`8888.       8 8888   \`8 8888       .8' 8 8888               88 8"
echo "8 8888     .888888888. \`88888. \`8b.  ;8.\`8888       8 8888      8888     ,88'  8 8888                  "
echo "8 8888    .8'       \`8. \`88888. \`Y8888P ,88P'       8 8888       \`8888888P'    8 8888                  "
echo ""
echo "888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888"
echo "888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888"
echo "888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888"
echo ""
sleep 1

# Just being fancy..
echo "Initializing installation functions and files..."

#Loading the actual functions in..
source install-functions.sh
loading

echo ""
echo "Please your password: (Leave empty for random password)"
read -s FASTCP_PASSWORD

if [[ "$FASTCP_PASSWORD" == "" ]];
    then
        FASTCP_PASSWORD="`random_password`"
fi

echo "Your password is ${FASTCP_PASSWORD}"
echo "Make sure you remember and/or write it down."
echo ""
# If this message show's the functions actually are loaded in
echo "Successfully initialized the installation functions and files!"
sleep 1

# TODO

