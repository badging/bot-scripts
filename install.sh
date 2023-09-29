#!/bin/sh
set -euxo pipefail #exit in case of errors

# install dependencies
while true; do
    echo -e '\e[91mPLEASE INPUT SUDO PASSWORD WHEN PROMPTED OTHERWISE TERMINAL WILL CLOSE SCRIPT\e[39m'
        
    system=$(uname)

    if [[ $system == "Linux" ]]; then
        echo -e "\xE2\x9D\x8C please input your password to proceed so that the setup runs successfully"
        echo

        if type -p curl >/dev/null || (sudo apt update && sudo apt install -y curl ) && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null && sudo apt update && sudo apt install gh -y && sudo apt install -y git nodejs npm; then
            echo
            break
        else
            echo -e "\xE2\x9D\x8C please input your password to proceed so that the setup runs successfully"
            return
        fi
        echo
        break

    elif [[ $system == "Darwin" ]]; then
        if brew update && brew install git gh curl node npm; then
            echo
            break
        else
            return
        fi
        echo
        break

    elif [[ $system == "CYGWIN" || "$(uname)" == * ]]; then
    packages=("git" "gh" "curl" "nodejs")

    for package in "${packages[@]}"; do
        if ! command -v "$package" &> /dev/null; then
            echo "Installing $package..."
            choco install -y "$package"
        else
            echo "$package is already installed."
        fi
    done
done
echo
#Configures git
read -p $'\e[1mEnter Github username: \e[22m' username
git config --global user.name $username
echo -e "\xE2\x9C\x94 set git username to $username"

read -p $'\e[1mEnter Github email: \e[22m' email
git config --global user.email $email
echo -e "\xE2\x9C\x94 set git email to $email"
echo

#Configures github CLI
echo -e '\e[1m----------------Logging in to GitHub CLI:----------------\e[22m'
gh auth login
echo -e '\xE2\x9C\x94 \e[1m----------------Logged in to GitHub CLI:----------------\e[22m'
echo

#fork and clone repositories
gh repo fork --clone=true https://github.com/badging/badging-bot.git
gh repo fork --clone=false https://github.com/badging/event-diversity-and-inclusion.git
echo

#configure github app
echo -e '\e[91mREAD CAREFULLY AND FOLLOW THE INSTRUCTIONS BELOW TO CONFIGURE YOUR LOCAL DEVELOPMENT ENVIRONMENT.\e[39m'
echo -e '\e[38;5;42mNavigate to https://github.com/settings/apps/new to create a new personal badging-bot Github test app.
This app will be installed on your test repository at https://github.com/$username/event-diversity-and-inclusion.
Since the app may be used to test a lot of use cases, ensure that all the access permissions are set to \e[1mRead and Write\e[22m and or all checkboxes are marked.\e[39m'

echo -e '\e[91mEnsure that you supply a Webhook URL and Webhook Secret for your new app.\e[39m'
echo -e '\e[38;5;42mFor the Webhook URL, visit https://smee.io, copy and paste the URL to the \e[1mWebhook URL section of the app\e[22m and also to the prompt below.\e[39m'
echo

#create temporary env file
touch .env
echo -e "\xE2\x9C\x94 created temporary .env file"
echo

read -p $'\e[1mEnter Webhook URL: \e[22m' webhookurl

#check whether URL is responsive
while true; do

    if  grep -q "200" <<< "$(curl -Is $webhookurl | head -1)" ; then
        echo -e "\xE2\x9C\x94 \e[1m\e[38;5;42m$webhookurl\e[39m is up and running\e[22m"
        echo
        break
    else
        echo -e "\xE2\x9D\x8C \e[1m\e[91m$webhookurl\e[39m is not responsive as intended.
        Please provide a working Webhook URL as pasted in your GitHub App settings from https://smee.io \e[22m"
        echo
        read -p $'\e[1mEnter Webhook URL: \e[22m' anotherURL
        webhookurl="$anotherURL"
    fi
done

echo "webhookURL=$webhookurl" >> .env
echo -e "\xE2\x9C\x94 set webhookURL to $webhookurl"
echo

read -p $'\e[1mEnter Webhook Secret: \e[22m' webhooksecret
echo "webhookSecret=$webhooksecret" >> .env
echo -e "\xE2\x9C\x94 set webhookSecret to $webhooksecret"
echo

echo -e '\e[38;5;42mOnce the app is created, you will be redirected to another page that will help you access the following
  1. App Id
  2. Client Id
  3. Client Secret (this will be generated and pasted in the prompt below)
  4. Private key (You will be required to download a PEM file and provide the FULL PATH to it in the prompt below)\e[39m'
echo

echo -e '\e[91mFill in the following information as set in your app settings\e[39m'
read -p $'\e[1mEnter App Id: \e[22m' appid
echo "appId=$appid" >> .env
echo -e "\xE2\x9C\x94 set appId to $appid"
echo

read -p $'\e[1mEnter Client Id: \e[22m' clientid
echo "clientId=$clientid" >> .env
echo -e "\xE2\x9C\x94 set clientId to $clientid"
echo

read -p $'\e[1mEnter Client Secret: \e[22m' clientsecret
echo "clientSecret=$clientsecret" >> .env
echo -e "\xE2\x9C\x94 set clientSecret to $clientsecret"
echo

read -p $'\e[1mEnter FULL PATH to downloaded PEM file: \e[22m' privatekeyPath
echo "privateKey='$(cat $privatekeyPath)'" >> .env
echo -e "\xE2\x9C\x94 set privateKey"
echo

echo "PORT=2020" >> .env
echo -e "\xE2\x9C\x94 set PORT to 2020"
echo

while true; do
    read -p $'\e[38;5;42mHave you installed the test app on your forked \e[1mevent-diversity-and-inclusion\e[22m repository? (y/n): \e[39m' answer

    if [ $answer == y ];then
        break
    else
        echo -e '\e[38;5;42mFor guidance, visit https://docs.github.com/en/developers/apps/managing-github-apps/installing-github-apps \e[39m'
        echo
    fi
done
echo

cd badging-bot
echo -e "\xE2\x9C\x94 moved to badging-bot directory"

mv ../.env . && rm -rf ../.env
echo -e "\xE2\x9C\x94 moved .env file to badging-bot directory"

npx -y husky-init && npm i

npm run dev
