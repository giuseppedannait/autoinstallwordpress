#!/bin/bash -e

# Auto Install Wordpress, version 1

#  Performed by Ing. Giuseppe D'Anna
#  -------
#  This script uses quite a number of features that will be explained later on.

clear
echo "============================================"
echo "WordPress Auto Install Script"
echo "============================================"
echo "Database Name: "
read -e dbname
echo "Database User: "
read -e dbuser
echo "Database Password: "
read -s dbpass
echo "Language to install (ex: it, en, us):"
read -s language
echo "run install? (y/n)"
read -e run

if [ "$run" == n ] ; then
    exit
else
    echo "============================================"
    echo "A robot is now installing WordPress for you."
    echo "============================================"
    
    # Download Wordpress
    curl -O https://wordpress.org/latest.tar.gz
    
    # Unzip Wordpress
    tar -zxvf latest.tar.gz
    
    # Change dir to wordpress
    cd wordpress
    
    # Copy file to parent dir
    cp -rf . ..
    
    # Move back to parent dir
    cd ..
    
    # Remove files from wordpress folder
    rm -R wordpress
    
    # Create wp config
    cp wp-config-sample.php wp-config.php
    
    # Set database details with perl find and replace
    perl -pi -e "s/database_name_here/$dbname/g" wp-config.php
    perl -pi -e "s/username_here/$dbuser/g" wp-config.php
    perl -pi -e "s/password_here/$dbpass/g" wp-config.php

    #Set WP salts
    perl -i -pe'
      BEGIN {
        @chars = ("a" .. "z", "A" .. "Z", 0 .. 9);
        push @chars, split //, "!@#$%^&*()-_ []{}<>~\`+=,.;:/?|";
        sub salt { join "", map $chars[ rand @chars ], 1 .. 64 }
      }
      s/put your unique phrase here/salt()/ge
    ' wp-config.php

    #create uploads folder and set permissions
    mkdir wp-content/uploads
    chmod 775 wp-content/uploads
    
    echo "Cleaning..."
    #remove zip file
    rm latest.tar.gz
    #remove bash script
    rm autoinstallwp.sh
    echo "========================="
    echo "Installation is complete."
    echo "========================="
fi
