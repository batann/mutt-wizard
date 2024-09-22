#!/bin/bash
clear
echo -e "\033[47m\033[34mPlease enter the email You would like to use:\033[0m"
read -p 'email address:   >>>   ' email_address
echo -e "\033[47m\033[34mPlease enter the password for your \033[31mGPG_KEY\033[0m"
read -p 'Password:   >>>   ' passphrase
echo -e "\033[47m\033[34mPlease enter Your Full Name:\033[0m"
read -p 'Full Name:   >>>   ' full_name
clear
echo -e "\033[44mThank YOU!!!\033[0m"
# List of dependencies to check
dependencies=('isync' 'urlview' 'pass' 'abook' 'ca-certificates' 'lynx' 'neomutt')



# Function to check if a package is installed
check_dependency() {
    dpkg -s "$1" >/dev/null 2>&1
}

# Collect missing packages
missing_packages=()
for dep in "${dependencies[@]}"; do
    if ! check_dependency "$dep"; then
        missing_packages+=("$dep")
        echo "$dep is not installed."
    fi
done

# If there are missing packages, ask for confirmation to install
if [ ${#missing_packages[@]} -gt 0 ]; then
 echo -e ""
 echo -e "\033[34m================================================\033[31m"
	read -n1 -p "Install missing packages? (y/n): " abc
    if [[ "$abc" == "y" || "$abc" == "Y" ]]; then
    echo -e "\033[0m"
		sudo apt-get install -y "${missing_packages[@]}"
    else
        echo "Installation aborted."
    fi
else
    echo -e "\033[47m\033[36mAll dependencies are installed.\033[0m"
fi

sleep 3
clear

###   Generate GPG key   ################################################
gpg --batch --full-generate-key <<EOF
    Key-Type: RSA
    Key-Length: 4096
    Subkey-Type: RSA
    Subkey-Length: 4096
    Name-Real: $full_name
    Name-Email: $email_address
   Expire-Date: 1y
    Passphrase: $passphrase
    %commit
EOF
clear
echo -e "\033[31mGPG key\033[0m generation completed. Please make sure to remember your passphrase."
read -n1 -p ' Press [any] to Continue ....' abc

cd /home/batan/mutt-wizard
sudo make install

